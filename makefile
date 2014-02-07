
test:
	cat test-in.txt | perl convert.pl | diff -u test-out.txt -
