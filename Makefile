CC?=gcc
CFLAGS+=-O3 -std=c99 -D_POSIX_C_SOURCE=1
TWEETNACLC=randombytes.c tools.c tweetnacl.c
TWEETNACL=$(TWEETNACLC) randombytes.h tools.h tweetnacl.h

all: tweetnacl-decrypt tweetnacl-encrypt tweetnacl-keypair \
     tweetnacl-sigpair tweetnacl-sign tweetnacl-verify

clean:
	rm -rf tweetnacl-decrypt tweetnacl-encrypt tweetnacl-keypair \
     	tweetnacl-sigpair tweetnacl-sign tweetnacl-verify

tweetnacl-decrypt: $(TWEETNACL) tweetnacl-decrypt.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-decrypt.c \
		-o $@

tweetnacl-encrypt: $(TWEETNACL) tweetnacl-encrypt.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-encrypt.c \
		-o $@

tweetnacl-keypair: $(TWEETNACL) tweetnacl-keypair.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-keypair.c \
		-o $@

tweetnacl-sigpair: $(TWEETNACL) tweetnacl-sigpair.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-sigpair.c \
		-o $@

tweetnacl-sign: $(TWEETNACL) tweetnacl-sign.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-sign.c \
		-o $@

tweetnacl-verify: $(TWEETNACL) tweetnacl-verify.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-verify.c \
		-o $@

test: ;
	mkdir tmp
	./tweetnacl-keypair tmp/a.pub tmp/a.sec
	./tweetnacl-keypair tmp/b.pub tmp/b.sec
	echo 'Secret message!' > tmp/msg01
	./tweetnacl-encrypt tmp/a.sec tmp/b.pub tmp/msg01 tmp/encrypted
	./tweetnacl-decrypt tmp/a.pub tmp/b.sec tmp/encrypted -
	./tweetnacl-sigpair tmp/s.pub tmp/s.sec
	echo 'Verified message!' > tmp/msg02
	./tweetnacl-sign tmp/s.sec tmp/msg02 tmp/signed
	./tweetnacl-verify tmp/s.pub tmp/signed -
	rm -rf tmp
