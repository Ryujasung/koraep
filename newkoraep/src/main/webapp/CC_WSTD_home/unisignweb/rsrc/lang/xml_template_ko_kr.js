(function() {
	return {
		KEY_REPLACE : " xmlns=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\t\n\t",
		KEY_START:	"<TaxInvoiceDocument>",
		KET_TARGET:	"</ExchangedDocument>",
		END_KEY: "</TaxInvoice>",
		
		XMLSignatureTemplate : 
			["<ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\">\n\
			<ds:SignedInfo>\n\
			<ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
			<ds:SignatureMethod Algorithm=\"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256\"/>\n\
			<ds:Reference URI=\"\">\n\
				<ds:Transforms>\n\
					<ds:Transform Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
					<ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n\
						<ds:XPath>not(self::*[name() = 'TaxInvoice'] | ancestor-or-self::*[name() = 'ExchangedDocument'] | ancestor-or-self::ds:Signature)</ds:XPath>\n\
					</ds:Transform>\n\
				</ds:Transforms>\n\
				<ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"/>\n\
				<ds:DigestValue>$$DV$$</ds:DigestValue>\n\
			</ds:Reference>\n\
		</ds:SignedInfo>\n\
		<ds:SignatureValue>$$Sign$$</ds:SignatureValue>\n\
		<ds:KeyInfo>\n\
		<ds:X509Data>\n\
		<ds:X509Certificate>$$Cert$$</ds:X509Certificate>\n\
		</ds:X509Data>\n\
		</ds:KeyInfo>\n\
	</ds:Signature>",
		"<ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\">\n\
		<ds:SignedInfo>\n\
			<ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
			<ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"/>\n\
			<ds:Reference URI=\"\">\n\
				<ds:Transforms>\n\
					<ds:Transform Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
					<ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n\
						<ds:XPath>not(self::*[name() = 'TaxInvoice'] | ancestor-or-self::*[name() = 'ExchangedDocument'] | ancestor-or-self::ds:Signature)</ds:XPath>\n\
					</ds:Transform>\n\
				</ds:Transforms>\n\
				<ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"/>\n\
				<ds:DigestValue>$$DV$$</ds:DigestValue>\n\
			</ds:Reference>\n\
		</ds:SignedInfo>\n\
		<ds:SignatureValue>$$Sign$$</ds:SignatureValue>\n\
		<ds:KeyInfo>\n\
		<ds:X509Data>\n\
		<ds:X509Certificate>$$Cert$$</ds:X509Certificate>\n\
		</ds:X509Data>\n\
		</ds:KeyInfo>\n\
	</ds:Signature>", ],
		
		XMLSignedInfoTemplate : [
			"<ds:SignedInfo xmlns=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n\
		<ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
		<ds:SignatureMethod Algorithm=\"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256\"/>\n\
		<ds:Reference URI=\"\">\n\
			<ds:Transforms>\n\
				<ds:Transform Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
				<ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n\
					<ds:XPath>not(self::*[name() = 'TaxInvoice'] | ancestor-or-self::*[name() = 'ExchangedDocument'] | ancestor-or-self::ds:Signature)</ds:XPath>\n\
				</ds:Transform>\n\
			</ds:Transforms>\n\
			<ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"/>\n\
			<ds:DigestValue>$$DV$$</ds:DigestValue>\n\
		</ds:Reference>\n\
		</ds:SignedInfo>",
		
		"<ds:SignedInfo xmlns=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n\
		<ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
		<ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"/>\n\
		<ds:Reference URI=\"\">\n\
			<ds:Transforms>\n\
				<ds:Transform Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\n\
				<ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n\
					<ds:XPath>not(self::*[name() = 'TaxInvoice'] | ancestor-or-self::*[name() = 'ExchangedDocument'] | ancestor-or-self::ds:Signature)</ds:XPath>\n\
				</ds:Transform>\n\
			</ds:Transforms>\n\
			<ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"/>\n\
			<ds:DigestValue>$$DV$$</ds:DigestValue>\n\
		</ds:Reference>\n\
	</ds:SignedInfo>"]
	}
})();		
		