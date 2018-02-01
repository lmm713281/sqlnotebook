import glob
import os

projectDirs = glob.glob("src/*")
projectNames = map(lambda x: os.path.basename(x), projectDirs)

meson = ""
with open("build/meson.build.template", "r") as templateFile:
    meson = templateFile.read()

for project in projectNames:
    valaSources = glob.glob("src/" + project + "/**/*.vala", recursive=True)
    cSources = glob.glob("src/" + project + "/**/*.c", recursive=True)
    sources = valaSources + cSources
    needle = "<sources-" + project + ">"
    quotedRelativeFilePaths = map(lambda x: "'" + x.replace("", "") + "'", sources)
    replacement = ",".join(quotedRelativeFilePaths)
    meson = meson.replace(needle, replacement)

print(meson)
