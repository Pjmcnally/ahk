def main():
    file_names = [
        "../rand_array_3.txt",
        "../rand_array_4.txt",
        "../rand_array_5.txt"
    ]

    for file in file_names:
        res = build_dict(file)

        values = res.values()
        total = sum(values)
        high = max(values)
        low = min(values)
        number = len(values)

        print("\nChecking file: {}".format(file))
        print("{} total entries found. High entry = {}. Low entry = {}".format(
            total, high, low))
        print("Average entry should ideally appear {} times".format(total/number))
        print()  # empty line
        print_dict(res)


def build_dict(file_name):
    res_dict = {}
    with open(file_name, "r") as f:
        for line in f:
            line = line.strip()
            res_dict[line] = res_dict.get(line, 0) + 1

    return res_dict


def print_dict(res_dict):
    for key in sorted(res_dict):
        print("{} was generated {} times".format(key, res_dict[key]))


if __name__ == '__main__':
    main()
