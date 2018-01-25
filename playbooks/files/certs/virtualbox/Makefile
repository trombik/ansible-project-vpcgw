ISPEC?=	ipsec
OPENSSL?=	openssl

CA_PUB?=	root_pub
CA_KEY?=	root_key
CA_DN?=	C=TH, O=trombik, CN=IPSec CA

PUB_DIR?=	certs
KEY_DIR?=	private

USERS?=	carol@strongswan.com
SERVERS?=	vpn1.jp.trombik.org

${CA_KEY}: ${CA_KEY}.der ${CA_KEY}.pem

${CA_KEY}.der:
	touch ${.TARGET}
	chmod 600 ${.TARGET}
	${IPSEC} pki --gen > ${.TARGET}

${CA_KEY}.pem:	${CA_KEY}.der
	touch ${.TARGET}
	chmod 600 ${.TARGET}
	${OPENSSL} rsa -inform der -in ${CA_KEY}.der -outform pem -out ${.TARGET}

${CA_PUB}:	${CA_PUB}.der ${CA_PUB}.pem

${CA_PUB}.der:	${CA_KEY}.der
	${IPSEC} pki --self --in "${CA_KEY}.der" --dn "${CA_DN}" --ca > ${.TARGET}

${CA_PUB}.pem:	${CA_PUB}.der
	${OPENSSL} x509 -inform der -in "${CA_PUB}.der" -outform pem -out ${.TARGET}

users:	${USERS}

servers:	${SERVERS}

.for ENTITIY in ${USERS} ${SERVERS}
__PKI_PUB_FLAGS=	--pub --in ${ENTITIY}_key.der
__PKI_ISSUE_FLAGS=	--issue \
			--cacert ${CA_PUB}.der \
			--cakey ${CA_KEY}.der \
			--san "${ENTITIY}" \
			--dn "C=TH, O=trombik.org CN=${ENTITIY}"
# if CN does not look like in user@domain format, assume it is a server.
# see https://wiki.strongswan.org/projects/strongswan/wiki/Win7CertReq
# and https://wiki.strongswan.org/projects/strongswan/wiki/AppleClients#Certificate-requirements-for-iOS-interoperability
.if empty(ENTITIY:M@)
__PKI_ISSUE_FLAGS+= --san "dns:${ENTITIY}" \
					--flag serverAuth \
					--flag ikeIntermediate
.endif

${ENTITIY}:	${ENTITIY}_key.der ${ENTITIY}_key.pem ${ENTITIY}_pub.der ${ENTITIY}_pub.pem

${ENTITIY}_key.der:
	touch ${.TARGET}
	chmod 600 ${.TARGET}
	${IPSEC} pki --gen > ${.TARGET}

${ENTITIY}_key.pem:	${ENTITIY}_key.der
	touch ${.TARGET}
	chmod 600 ${.TARGET}
	${OPENSSL} rsa -in ${ENTITIY}_key.der -inform der -outform pem -out ${.TARGET}


${ENTITIY}_pub.der:
	${IPSEC} pki ${__PKI_PUB_FLAGS} | ${IPSEC} pki ${__PKI_ISSUE_FLAGS} > ${.TARGET}

${ENTITIY}_pub.pem:	${ENTITIY}_pub.der
	${OPENSSL} x509 -in ${ENTITIY}_pub.der -inform der -outform pem -out ${.TARGET}

.endfor

clean_ca:
	rm -f ${CA_PUB}.der ${CA_PUB}.pem  ${CA_KEY}.der ${CA_KEY}.pem

clean_users:
.for USER in ${USERS}
	rm -f ${USER}_pub.der ${USER}_key.der ${USER}_pub.pem ${USER}_key.pem
.endfor

clean_servers:
.for SERVER in ${SERVERS}
	rm -f ${SERVER}_pub.der ${SERVER}_key.der ${SERVER}_pub.pem ${SERVER}_key.pem
.endfor

clean_all: clean_ca clean_users clean_servers

clean:
	@echo "The Mankefile intensionally does not implement clean target. Use clean_ca, clean_users, or clean_servers target instead." && exit 1

all:	${CA_KEY} ${CA_PUB} servers users

.MAIN:	all
