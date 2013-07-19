int main(string[] args) {
	if (args.length != 2) {
		print("Usage: digestHtml maxcount < file\n");
		return 1;
	}

	int maxCount = int.parse(args[1]);

	var tagRe = new Regex("<[^>]*>");

	var sb = new StringBuilder();
	int count = 0;

	string line = stdin.read_line();
	while (line != null) {
		line = line.replace("</p>", "\x7f");
		line = line.replace("<br />", "\x7f");
		line = line.replace("</li>", "\x7f");
		line = tagRe.replace(line, -1, 0, "");

		unichar c;
		for (int i = 0; line.get_next_char(ref i, out c);) {
			sb.append_unichar(c);
			if (c == '&') {
				while (line.get_next_char(ref i, out c)) {
					sb.append_unichar(c);
					if (c == ';') {
						break;
					}
				}
			}
			count++;
			if (count >= maxCount) {
				break;
			}
		}
		if (count >= maxCount) {
			break;
		}

		line = stdin.read_line();
	}
	stdout.puts(sb.str.replace("\x7f", "<br />"));
	stdout.putc('\n');
	return 0;
}
