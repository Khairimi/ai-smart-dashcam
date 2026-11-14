"""CI diagnostics only: republish failing `flutter test` output as GitHub
annotations so it is readable without admin access to raw logs.
Does not change test results."""
import re
import sys

text = open(sys.argv[1], errors="replace").read()
text = re.sub(r"\x1b\[[0-9;]*[A-Za-z]", "", text)
starts = [m.start() for m in re.finditer(r"\[E\]", text)]
chunks = [text[max(0, i - 300): i + 2800] for i in starts[:8]]
if not chunks:
    chunks = [text[-4000:]]
for c in chunks:
    c = c.replace("%", "%25").replace("\r", "").replace("\n", "%0A")
    print("::error title=test-failure::" + c[:3500])
