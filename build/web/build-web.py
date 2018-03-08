import glob
import os
import subprocess
import shutil
import re
import io

def get_title(md_file_path, suffix = '', allow_markdown=True):
    title = ''
    with open(md_file_path, 'r', encoding='utf-8') as f:
        for line in f.readlines():
            if line.startswith('# '):
                title = line[2:].strip()
    if suffix != '':
        if title == '':
            title = suffix
        else:
            title = title + ' - ' + suffix
    if allow_markdown == False:
        title = title.replace('`', '')
    return title

def create_containing_directory(file_path):
    path = os.path.dirname(file_path)
    os.makedirs(path, exist_ok=True)

def preprocess_all_md_page_files():
    prefix = '/source/web/pages/'
    for file_path in glob.glob(prefix + '**/*.md', recursive=True):
        relative_file_path = file_path[len(prefix):]
        
        # read the unprocessed markdown
        md = ''
        with open(file_path, 'r', encoding='utf-8') as g:
            md = g.read()
            
        # generate the breadcrumb bar
        crumb = ''
        parent = os.path.dirname(file_path)
        if os.path.basename(file_path) == 'index.md':
            parent = os.path.dirname(parent)
        while len(parent) > len(prefix):
            title = get_title(os.path.join(parent, 'index.md'))
            if crumb != '':
                crumb = ' <span class="crumb-separator">»</span> ' + crumb
            crumb = '[' + title + '](/' + parent.replace(prefix, '') + '/index.html)' + crumb
            parent = os.path.dirname(parent)
        if crumb != '':
            md = '<nav><p id="crumb">' + crumb + '</p></nav>\n\n' + md
            
        # generate railroad diagrams
        rr_continue = True
        while rr_continue:
            rr_continue = False
            rr_start_index = md.find('<railroad-diagram>')
            if rr_start_index != -1:
                rr_continue = True
                rr_end_index = md.find('</railroad-diagram>')
                rr_partial_code = md[rr_start_index + len('<railroad-diagram>'):rr_end_index]
                # rr_partial_code is the part inside a Diagram() call
                with open('/source/obj-web/rr', 'w') as f:
                    f.write('')
                rr_diagram_code = ('import sys\n' +
                    "sys.path.append('/source/ext/railroad-diagrams')\n" +
                    'from railroad_diagrams import *\n' +
                    'with open("/source/obj-web/rr", "w") as f:\n' +
                    '    Diagram(' + rr_partial_code + ').writeSvg(f.write)')
                exec(rr_diagram_code)
                rr_svg = ''
                with open('/source/obj-web/rr', 'r') as f:
                    rr_svg = f.read()
                # insert the svg
                md = md[:rr_start_index] + rr_svg + md[rr_end_index + len('</railroad-diagram>'):]
        
        # write the processed markdown
        obj_file_path = os.path.join('/source/obj-web', relative_file_path)
        create_containing_directory(obj_file_path)
        with open(obj_file_path, 'w', encoding='utf-8') as f:
            f.write(md)

def add_tree_to_doc_index_md_files():
    root_prefix = '/source/obj-web'
    for file_path in sorted(glob.glob('/source/obj-web/doc/**/index.md', recursive=True)):
        dir_path = os.path.dirname(file_path)
        lines = get_tree_md_lines(dir_path, root_prefix, '')
        md = ''
        with open(file_path, 'r', encoding='utf-8') as f:
            md = f.read()
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(md)
            f.write('\n\n<div id="toc">\n')
            f.write('\n'.join(lines))
            f.write('\n</div>\n')

def get_tree_md_lines(dir_path, root_prefix, indent):
    lines = []
    for subfolder_path in sorted(glob.glob(dir_path + '/*/', recursive=False)):
        subfolder_relative_path = subfolder_path[len(root_prefix):-1] + '/index.html'
        subfolder_title = get_title(subfolder_path + '/index.md')
        lines.append('{0}- [{1}]({2})'.format(indent, subfolder_title, subfolder_relative_path))
        for line in get_tree_md_lines(subfolder_path, root_prefix, indent + '    '):
            lines.append(line)
    for document_file_path in sorted(glob.glob(dir_path + '/*.md', recursive=False)):
        document_relative_path = document_file_path[len(root_prefix):-3] + '.html'
        if os.path.basename(document_file_path) != 'index.md':
            document_title = get_title(document_file_path)
            lines.append('{0}- [{1}]({2})'.format(indent, document_title, document_relative_path))
    return lines

def convert_all_md_files_to_html_files():
    page_html_template = ''
    with open('/source/web/templates/page.html', 'r', encoding='utf-8') as f:
        page_html_template = f.read()
    with open('/source/web/templates/style.css', 'r', encoding='utf-8') as f:
        css = '<style>' + f.read() + '</style>'
        page_html_template = page_html_template.replace('<!--CSS-->', css)
    for md_file_path in glob.glob('/source/obj-web/**/*.md', recursive=True):
        directory_path, md_file_name = os.path.split(md_file_path)
        name, extension = os.path.splitext(md_file_name)
        html_fragment_file_path = os.path.join(directory_path, name + '.html_fragment')
        bin_directory_path = directory_path.replace('/obj-web', '/bin-web')
        html_file_path = os.path.join(bin_directory_path, name + '.html')
        create_containing_directory(html_file_path)
        pandoc_args = ['pandoc', '-f', 'markdown-auto_identifiers-implicit_figures+backtick_code_blocks', '-t', 'html', '-o', html_fragment_file_path, md_file_path]
        subprocess.call(pandoc_args)
        with open(html_fragment_file_path, 'r', encoding='utf-8') as f:
            title = get_title(md_file_path, 'SQL Notebook', allow_markdown=False)
            content = f.read()
            page_html = page_html_template.replace('<!--TITLE-->', title).replace('<!--CONTENT-->', content)
            with open(html_file_path, 'w', encoding='utf-8') as g:
                g.write(page_html)
            print(html_file_path)

def copy_static_assets():
    prefix = '/source/web/assets/'
    for file_path in glob.glob(prefix + '**/*.*', recursive=True):
        relative_file_path = file_path[len(prefix):]
        bin_file_path = os.path.join('/source/bin-web', relative_file_path)
        create_containing_directory(bin_file_path)
        shutil.copyfile(file_path, bin_file_path)
        print(bin_file_path)

def generate_website():
    os.mkdir('/source/obj-web')
    os.mkdir('/source/bin-web')
    copy_static_assets()
    md_file_paths = glob.glob('/source/web/pages/**/*.md', recursive=True)
    preprocess_all_md_page_files()
    add_tree_to_doc_index_md_files()
    convert_all_md_files_to_html_files()

generate_website()
