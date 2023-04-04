import glob

for filename in glob.glob('**/*.uc', recursive=True):
    with open(filename, "r") as input_file:
        with open(f"{filename}.txt", "w") as output_file:
            line_number = 1
            for line in input_file:
                line = line.replace('\t','')
                if line.startswith('say("') or line.count('= "') > 0 or line.count('item.say("'):
                    output_file.write(f"Linea {line_number}: {line}")
                line_number += 1
    print(f"{line_number} lineas en {filename}")