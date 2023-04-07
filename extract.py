import glob
import re
import openai
openai.api_key = ""

pattern = r'"(?:[^"]|(?:"[^"]*"))*"'

for filename in glob.glob('**/*.uc', recursive=True):
    with open(filename, "r") as input_file:
        print(f"Trabajando en {filename}\n")
        with open(f"{filename}.md", "w") as output_file:
            output_file.write("|Line|Sentence|String|Spanish\n|-|-|-|-|\n")
            line_number = 1
            for line in input_file:
                line = line.replace('\t','').replace('\n','')
                if line.startswith('say("') or line.count('= "') > 0 or line.count('item.say("'):

                    result = re.search(pattern, line)

                    response = openai.Completion.create(
                        engine="text-davinci-002",
                        prompt="Traduce esto al español y que suene a español antiguo: "+result.group(),
                        temperature=0.5,
                        max_tokens=1024,
                        n=1,
                        stop=None,
                        )                        
                    traduccion = response.choices[0].text.strip()
                    output_file.write(f"[{line_number}]|{line}|{result.group()}|{traduccion}\n")
                    print(".", end='')
                line_number += 1
    print(f"\n{line_number} lineas en {filename}\n")