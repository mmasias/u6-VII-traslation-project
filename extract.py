import glob
import re

pattern = r'"(?:[^"]|(?:"[^"]*"))*"'

for filename in glob.glob('**/*.uc', recursive=True):
    with open(filename, "r") as input_file:
        with open(f"{filename}.md", "w") as output_file:
            output_file.write("|Line|Sentence|String|\n|-|-|-|\n")
            line_number = 1
            for line in input_file:
                line = line.replace('\t','').replace('\n','')
                if line.startswith('say("') or line.count('= "') > 0 or line.count('item.say("'):

                    result = re.search(pattern, line)
                    output_file.write(f"[{line_number}]|{line}|{result.group()}\n")
                line_number += 1
    print(f"{line_number} lineas en {filename}")