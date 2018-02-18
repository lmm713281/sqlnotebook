import glob
import os
from sys import platform as _platform

projectDirs = glob.glob("src/*")
projectNames = map(lambda x: os.path.basename(x), projectDirs)

meson = ""
with open("build/meson.build.template", "r") as templateFile:
    meson = templateFile.read()

for project in projectNames:
    valaSources = glob.glob("src/" + project + "/**/*.vala", recursive=True)
    vapiSources = glob.glob("src/" + project + "/**/*.vapi", recursive=True)
    cSources = glob.glob("src/" + project + "/**/*.c", recursive=True)
    sources = valaSources + vapiSources + cSources
    needle = "<sources-" + project + ">"
    quotedRelativeFilePaths = map(lambda x: "'" + x + "'", sources)
    replacement = ",".join(quotedRelativeFilePaths)
    meson = meson.replace(needle, replacement)

if _platform == "darwin":
	meson = meson.replace("<homebrew-include-path>", "'" + "obj-mac/homebrew/include" + "'")
	meson = meson.replace("<homebrew-lib-path>", "'" + os.getcwd() + "/obj-mac/homebrew/lib" + "'")
else:
	meson = meson.replace("<homebrew-include-path>", "")
	meson = meson.replace("<homebrew-lib-path>", "")

print(meson)
