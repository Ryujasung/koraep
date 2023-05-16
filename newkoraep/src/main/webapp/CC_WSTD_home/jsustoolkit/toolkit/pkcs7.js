(function(){function s(c){var k=c.jsustoolkitErrCode=c.jsustoolkitErrCode||{},a=c.asn1,m=c.pkcs7=c.pkcs7||{};m.messageFromPem=function(b){if(null==e||"undefined"==typeof e)throw{code:"113001",message:k["113001"]};b=c.pki.pemToDer(b);var e=a.fromDer(b);return m.messageFromAsn1(e)};m.messageToPem=function(b,e){if(null==b||"undefined"==typeof b)throw{code:"113002",message:k["113002"]};var f=a.toDer(b.toAsn1()),f=c.util.encode64(f.getBytes(),e||64);return"-----BEGIN PKCS7-----\r\n"+f+"\r\n-----END PKCS7-----"};m.messageFromBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"113003",message:k["113003"]};b=c.pki.base64ToDer(b);b=a.fromDer(b);return m.messageFromAsn1(b)};m.messageToBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"113004",message:k["113004"]};b=a.toDer(b.toAsn1());return c.util.encode64(b.getBytes())};m.messageFromAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"113005",message:k["113005"]};var e={},f=[];if(!a.validate(b,m.asn1.contentInfoValidator,e,f))throw{code:"113006",message:k["113006"],errors:f};b=a.derToOid(e.contentType);switch(b){case c.pki.oids.envelopedData:b=m.createEnvelopedData();break;case c.pki.oids.encryptedData:b=m.createEncryptedData();break;case c.pki.oids.signedData:b=m.createSignedData();break;default:throw{code:"113007",message:k["113007"]+"("+b+")"};}b.fromAsn1(e.content.value[0]);return b};var p=function(b){var e={},f=[];if(!a.validate(b,m.asn1.recipientInfoValidator,e,f))throw{code:"113008",message:k["113008"],errors:f};return{version:e.version.charCodeAt(0),issuer:c.pki.RDNAttributesAsArray(e.issuer),serialNumber:c.util.createBuffer(e.serial).toHex(),encContent:{algorithm:a.derToOid(e.encAlgorithm),parameter:e.encParameter.value,content:e.encKey}}},r=function(b){return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[c.pki.distinguishedNameToAsn1({attributes:b.issuer}),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,c.util.hexToBytes(b.serialNumber))]),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.encContent.algorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]),a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.encContent.content)])},s=function(a){for(var e=[],c=0;c<a.length;c++)e.push(r(a[c]));return e},q=function(b){return[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.data).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.algorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.parameter.getBytes())]),a.create(a.Class.CONTEXT_SPECIFIC,0,!1,b.content.getBytes())]},t=function(b,e,f){if(null==b||"undefined"==typeof b)throw{code:"113009",message:k["113009"]};if(null==e||"undefined"==typeof e)throw{code:"113010",message:k["113010"]};if(null==f||"undefined"==typeof f)throw{code:"113011",message:k["113011"]};var d={},g=[];if(!a.validate(e,f,d,g))throw{code:"113012",message:k["113012"],errors:g};if(a.derToOid(d.contentType)!==c.pki.oids.data)throw{code:"113013",message:k["113013"]};if(d.encContent){e="";if(d.encContent.constructor===Array)for(var h=0;h<d.encContent.length;++h){if(d.encContent[h].type!==a.Type.OCTETSTRING)throw{code:"113014",message:k["113014"]};e+=d.encContent[h].value}else e=d.encContent;b.encContent={algorithm:a.derToOid(d.encAlgorithm),parameter:c.util.createBuffer(d.encParameter.value),content:c.util.createBuffer(e)}}if(d.content){e="";if(d.content.constructor===Array)for(h=0;h<d.content.length;++h){if(d.content[h].type!==a.Type.OCTETSTRING)throw{code:"113015",message:k["113015"]};e+=d.content[h].value}else e=d.content.constructor===Object?d.content.value[0].value:d.content;b.content=c.util.createBuffer(e)}if(d.signature){for(h in d.certificates)b.certificates.push(c.pki.certificateFromAsn1(d.certificates[h]));b.crls=d.crls;b.signContent.push(d.signerInfos);b.digestAlgo.push(a.derToOid(d.digestAlgorithm));b.authenticatedAttributes.push(d.authenticatedAttributes);b.signature.push(d.signature)}b.version=d.version.charCodeAt(0);return b.rawCapture=d},u=function(a){if(null==a||"undefined"==typeof a)throw{code:"113016",message:k["113016"]};if(void 0===a.encContent.key)throw{code:"113017",message:k["113017"]};if(void 0===a.content){var e;switch(a.encContent.algorithm){case c.pki.oids["aes128-CBC"]:case c.pki.oids["aes192-CBC"]:case c.pki.oids["aes256-CBC"]:e=c.aes.createDecryptionCipher(a.encContent.key);break;case c.pki.oids["des-EDE3-CBC"]:e=c.des.createDecryptionCipher(a.encContent.key);break;case c.pki.oids["seed-CBC"]:e=c.seed.createDecryptionCipher(a.encContent.key);break;default:throw{code:"113018",message:k["113018"]+a.encContent.algorithm};}e.start(a.encContent.parameter);e.update(a.encContent.content);if(!e.finish())throw{code:"113019",message:k["113019"]};a.content=e.output}},v=function(a,e,f){if(null==a||"undefined"==typeof a)throw{code:"113020",message:k["113020"]};if(void 0===a.encContent.content){f=f||a.encContent.algorithm;e=e||a.encContent.key;var d,g,h;switch(f){case c.pki.oids["aes128-CBC"]:g=d=16;h=c.aes.createEncryptionCipher;break;case c.pki.oids["aes192-CBC"]:d=24;g=16;h=c.aes.createEncryptionCipher;break;case c.pki.oids["aes256-CBC"]:d=32;g=16;h=c.aes.createEncryptionCipher;break;case c.pki.oids["des-EDE3-CBC"]:d=24;g=8;h=c.des.createEncryptionCipher;break;case c.pki.oids["seed-CBC"]:g=d=16;h=c.seed.createEncryptionCipher;break;default:throw{code:"113021",message:k["113021"]+f};}if(void 0===e)e=c.util.createBuffer(c.random.getBytes(d));else if(e.length()!=d)throw{code:"113022",message:k["113022"]+"got "+e.length()+" bytes, expected "+d};a.encContent.algorithm=f;a.encContent.key=e;a.encContent.parameter=c.util.createBuffer(c.random.getBytes(g));e=h(e);e.start(a.encContent.parameter.copy());e.update(a.content);if(!e.finish())throw{code:"113023",message:k["113023"]};a.encContent.content=e.output}},x=function(b){if(null==b||"undefined"==typeof b)throw{code:"113024",message:k["113024"]};var e=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);e.value.push(a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)));e.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[c.pki.distinguishedNameToAsn1({attributes:b.issuer}),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,c.util.hexToBytes(b.serialNumber))]));e.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.digestAlgorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]));b.authAttr&&e.value.push(a.create(a.Class.CONTEXT_SPECIFIC,0,!0,b.authAttr.value));e.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.digestEncAlgorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]));e.value.push(a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.signature));return e},w=function(b){if(null==b||"undefined"==typeof b)throw{code:"113025",message:k["113025"]};var e=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);e.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.contentType).getBytes()));e.value.push(a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.data).getBytes())]));var f=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);f.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.signingTime).getBytes()));f.value.push(a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.GENERALIZEDTIME,!1,a.dateToGeneralizedTime(b.signTime))]));var d=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);d.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.messageDigest).getBytes()));d.value.push(a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.digest)]));b=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);b.value.push(e);b.value.push(f);b.value.push(d);return b};m.createSignedData=function(){var b=null;return b={type:c.pki.oids.signedData,version:1,certificates:[],crls:[],signature:[],signContent:[],authenticatedAttributes:[],digestAlgo:[],fromAsn1:function(a){if(null==a||"undefined"==typeof a)throw{code:"113026",message:k["113026"]};t(b,a,m.asn1.signedDataValidator)},toAsn1:function(){var e=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);e.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.type).getBytes()));var f=a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[]),d=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);d.value.push(a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)));for(var g=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]),h=0;h<b.signContent.length;h++)g.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.signContent[h].digestAlgorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]));d.value.push(g);b.content?d.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.data).getBytes()),a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.content.getBytes())])])):d.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.data).getBytes())]));if(0!=b.certificates.length){g=a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[]);for(h=0;h<b.certificates.length;h++)g.value.push(c.pki.certificateToAsn1(b.certificates[h]));d.value.push(g)}if(0!=b.crls.length){g=a.create(a.Class.CONTEXT_SPECIFIC,1,!0,[]);for(h=0;h<b.crls.length;h++)g.value.push(b.crls[h].getBytes());d.value.push(g)}if(0<b.signContent.length){g=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);for(h=0;h<b.signContent.length;h++)g.value.push(x(b.signContent[h]));d.value.push(g)}else throw{code:"113027",message:k["113027"]};f.value.push(d);e.value.push(f);return e},signWithDecPriKey:function(e,f,d,g,h){if(null==f||"undefined"==typeof f)throw{code:"113028",message:k["113028"]};if(null==d||"undefined"==typeof d)throw{code:"113029",message:k["113029"]};if(null==e||"undefined"==typeof e)e="";b.content=c.util.createBuffer(e,"utf8");e={version:1,digestAlgorithm:c.pki.oids.sha256};var n=c.pki.oids[f.siginfo.algorithmOid].split("With");e.digestAlgorithm=c.pki.oids[n[0]];e.digestEncAlgorithm=c.pki.oids[n[1]];e.issuer=f.issuer.attributes;e.serialNumber=f.serialNumber;b.certificates.push(f);e.signTime=void 0!==typeof g&&null!=g?g:new Date;void 0!==typeof h&&null!=h&&b.crls.push(h);f=c.md.algorithms[c.pki.oids[e.digestAlgorithm]].create();f.update(b.content.bytes());e.digest=f.digest().bytes();e.authAttr=w(e);f=c.md.algorithms[c.pki.oids[e.digestAlgorithm]].create();g=a.toDer(e.authAttr);f.update(g.bytes());e.signature=d.sign(f);b.signContent.push(e)},sign:function(a,f,d,g,h,n){if(null==g||"undefined"==typeof g)throw{code:"113030",message:k["113030"]};if(null==d||"undefined"==typeof d)throw{code:"113031",message:k["113031"]};d=c.pkcs8.decryptPrivateKeyInfo(d,g);d=c.pki.privateKeyFromAsn1(d);b.signWithDecPriKey(a,f,d,h,n)},signWithHashWithDecPriKey:function(e,f,d,g,h,n){if(null==d||"undefined"==typeof d)throw{code:"113028",message:k["113028"]};if(null==g||"undefined"==typeof g)throw{code:"113029",message:k["113029"]};if(null==e||"undefined"==typeof e)e="";var l={version:1,digestAlgorithm:c.pki.oids.sha256},m=c.pki.oids[d.siginfo.algorithmOid].split("With");l.digestAlgorithm=c.pki.oids[f];l.digestEncAlgorithm=c.pki.oids[m[1]];l.issuer=d.issuer.attributes;l.serialNumber=d.serialNumber;b.certificates.push(d);l.signTime=void 0!==typeof h&&null!=h?h:new Date;void 0!==typeof n&&null!=n&&b.crls.push(n);l.digest=e;l.authAttr=w(l);md=c.md.algorithms[c.pki.oids[l.digestAlgorithm]].create();e=a.toDer(l.authAttr);md.update(e.bytes());l.signature=g.sign(md);b.signContent.push(l)},signWithHashData:function(a,f,d,g,h,n,l){if(null==h||"undefined"==typeof h)throw{code:"113030",message:k["113030"]};if(null==g||"undefined"==typeof g)throw{code:"113031",message:k["113031"]};g=c.pkcs8.decryptPrivateKeyInfo(g,h);g=c.pki.privateKeyFromAsn1(g);b.signWithHashWithDecPriKey(a,f,d,g,n,l)},signWithHashDataNP1:function(a,f,d,g,h,n){if(null==g||"undefined"==typeof g)throw{code:"113028",message:k["113028"]};if(null==f||"undefined"==typeof f)f="";if(null==a||"undefined"==typeof a)a="";var l={version:1,digestAlgorithm:c.pki.oids.sha256},m=c.pki.oids[g.siginfo.algorithmOid].split("With");l.digestAlgorithm=c.pki.oids[d];l.digestEncAlgorithm=c.pki.oids[m[1]];l.issuer=g.issuer.attributes;l.serialNumber=g.serialNumber;b.certificates.push(g);l.signTime=void 0!==typeof h&&null!=h?h:new Date;void 0!==typeof n&&null!=n&&b.crls.push(n);l.digest=f;l.signature=a;b.signContent.push(l)},signWithP1:function(a,f,d,g,h){if(null==d||"undefined"==typeof d)throw{code:"113028",message:k["113028"]};if(null==f||"undefined"==typeof f)f="";b.content=c.util.createBuffer(f,"utf8");f={version:1,digestAlgorithm:c.pki.oids.sha256};var n=c.pki.oids[d.siginfo.algorithmOid].split("With");f.digestAlgorithm=c.pki.oids[n[0]];f.digestEncAlgorithm=c.pki.oids[n[1]];f.issuer=d.issuer.attributes;f.serialNumber=d.serialNumber;b.certificates.push(d);f.signTime=void 0!==typeof g&&null!=g?g:new Date;void 0!==typeof h&&null!=h&&b.crls.push(h);d=c.md.algorithms[c.pki.oids[f.digestAlgorithm]].create();d.update(b.content.bytes());f.digest=d.digest().bytes();f.signature=a;b.signContent.push(f)},verifyWithHash:function(e){if("undefined"!=typeof certs)if(cert.constructor===Array)for(var f in certs)b.certificates.push(certs[f]);else b.certificates.push(certs);if(null==e||"undefined"==typeof e)throw{code:"113043",message:k["113043"]};if(b.certificates.length!=b.signContent.length)throw{code:"113042",message:k["113042"]};for(f=0;f<b.certificates.length;f++){var d=b.certificates[f].publicKey,g,h=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);if("undefined"!=typeof b.authenticatedAttributes[0])for(var n in b.authenticatedAttributes[f]){c.pki.oids.messageDigest!=a.derToOid(b.authenticatedAttributes[f][n].value[0].value)&&c.pki.oids.signingTime==a.derToOid(b.authenticatedAttributes[f][n].value[0].value)&&(23==b.authenticatedAttributes[f][n].value[1].value[0].type?b.signTime=a.utcTimeToDate(b.authenticatedAttributes[f][n].value[1].value[0].value):24==b.authenticatedAttributes[f][n].value[1].value[0].type&&(b.signTime=a.generalizedTimeToDate(b.authenticatedAttributes[f][n].value[1].value[0].value)));h.value.push(b.authenticatedAttributes[f][n]);g=c.md.algorithms[c.pki.oids[b.digestAlgo[f]]].create();g.update(a.toDer(h).bytes());b.verifyResult=!1;try{b.verifyResult=d.verify(g.digest().getBytes(),b.signature[f])}catch(l){b.verifyResult=!1}}else{g=e;var m=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);m.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.contentType).getBytes()));m.value.push(a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.data).getBytes())]));h.value.push(m);m=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);m.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.pki.oids.messageDigest).getBytes()));m.value.push(a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,g)]));h.value.push(m);try{b.verifyResult=d.verify(g,b.signature[f])}catch(p){b.verifyResult=!1}}}},addSign:function(a,b,d){},verify:function(e,f){if("undefined"!=typeof e)if(cert.constructor===Array)for(var d in e)b.certificates.push(e[d]);else b.certificates.push(e);"undefined"!=typeof f&&(b.content=c.util.createBuffer(f,"utf8"));if(b.certificates.length!=b.signContent.length)throw{code:"113042",message:k["113042"]};for(d=0;d<b.certificates.length;d++){var g=b.certificates[d].publicKey,h,n=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);if("undefined"!=typeof b.authenticatedAttributes[0]){for(var l in b.authenticatedAttributes[d])c.pki.oids.messageDigest==a.derToOid(b.authenticatedAttributes[d][l].value[0].value)?h=b.authenticatedAttributes[d][l].value[1].value[0].value:c.pki.oids.signingTime==a.derToOid(b.authenticatedAttributes[d][l].value[0].value)&&(23==b.authenticatedAttributes[d][l].value[1].value[0].type?b.signTime=a.utcTimeToDate(b.authenticatedAttributes[d][l].value[1].value[0].value):24==b.authenticatedAttributes[d][l].value[1].value[0].type&&(b.signTime=a.generalizedTimeToDate(b.authenticatedAttributes[d][l].value[1].value[0].value))),n.value.push(b.authenticatedAttributes[d][l]);var m=c.md.algorithms[c.pki.oids[b.digestAlgo]].create();m.update(b.content.bytes());m.digest().bytes()==h?b.verifyResult=!0:b.verifyResult=!1;n=a.toDer(n).bytes()}else n=b.content.bytes();m=c.md.algorithms[c.pki.oids[b.digestAlgo[d]]].create();m.update(n);b.verifyResult=!1;try{b.verifyResult=g.verify(m.digest().getBytes(),b.signature[d])}catch(p){b.verifyResult=!1}}}}};m.createEncryptedData=function(){var b=null;return b={type:c.pki.oids.encryptedData,version:0,encContent:{algorithm:c.pki.oids["seed-CBC"]},fromAsn1:function(a){if(null==a||"undefined"==typeof a)throw{code:"113032",message:k["113032"]};t(b,a,m.asn1.encryptedDataValidator)},toAsn1:function(){return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.type).getBytes()),a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,q(b.encContent))])])])},encrypt:function(a,f){if(null==a||"undefined"==typeof a)throw{code:"113033",message:k["113033"]};a=c.util.createBuffer(a);v(b,a,f)},decrypt:function(a){if(null==a||"undefined"==typeof a)throw{code:"113034",message:k["113034"]};a=c.util.createBuffer(a);b.encContent.key=a;u(b)}}};m.createEnvelopedData=function(){var b=null;return b={type:c.pki.oids.envelopedData,version:0,recipients:[],encContent:{algorithm:c.pki.oids["seed-CBC"]},fromAsn1:function(a){if(null==a||"undefined"==typeof a)throw{code:"113035",message:k["113035"]};var c=t(b,a,m.asn1.envelopedDataValidator);a=b;for(var c=c.recipientInfos.value,d=[],g=0;g<c.length;g++)d.push(p(c[g]));a.recipients=d},toAsn1:function(){return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.type).getBytes()),a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)),a.create(a.Class.UNIVERSAL,a.Type.SET,!0,s(b.recipients)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,q(b.encContent))])])])},findRecipient:function(a){if(null==a||"undefined"==typeof a)throw{code:"113036",message:k["113036"]};for(var c=a.issuer.attributes,d=0;d<b.recipients.length;++d){var g=b.recipients[d],h=g.issuer;if(g.serialNumber===a.serialNumber&&h.length===c.length){for(var m=!0,l=0;l<c.length;++l)if(h[l].type!==c[l].type||h[l].value!==c[l].value){m=!1;break}if(m)return g}}},decrypt:function(a,f){if(null==a||"undefined"==typeof a)throw{code:"113037",message:k["113037"]};if(null==f||"undefined"==typeof f)throw{code:"113038",message:k["113038"]};if(void 0===b.encContent.key&&void 0!==a&&void 0!==f)switch(a.encContent.algorithm){case c.pki.oids.RSAEncryption:var d=f.decrypt(a.encContent.content);b.encContent.key=c.util.createBuffer(d);break;default:throw{code:"113039",message:k["113039"]+"( OID : "+a.encContent.algorithm+")"};}u(b)},addRecipient:function(a){if(null==a||"undefined"==typeof a)throw{code:"113040",message:k["113040"]};b.recipients.push({version:0,issuer:a.issuer.attributes,serialNumber:a.serialNumber,encContent:{algorithm:c.pki.oids.RSAEncryption,key:a.publicKey}})},encrypt:function(a,f){v(b,a,f);for(var d=0;d<b.recipients.length;d++){var g=b.recipients[d];if(void 0===g.encContent.content)switch(g.encContent.algorithm){case c.pki.oids.RSAEncryption:g.encContent.content=g.encContent.key.encrypt(b.encContent.key.data);break;default:throw{code:"113041",message:k["113041"]};}}}}}}var q="./aes ./seed ./asn1 ./des ./pkcs7asn1 ./pki ./random ./util ./jsustoolkitErrCode".split(" "),r=null;"function"!==typeof define&&("object"===typeof module&&module.exports?r=function(c,k){k(require,module)}:(crosscert=window.crosscert=window.crosscert||{},s(crosscert)));(r||"function"===typeof define)&&(r||define)(["require","module"].concat(q),function(c,k){k.exports=function(a){var k=q.map(function(a){return c(a)}).concat(s);a=a||{};a.defined=a.defined||{};if(a.defined.pkcs7)return a.pkcs7;a.defined.pkcs7=!0;for(var p=0;p<k.length;++p)k[p](a);return a.pkcs7}})})();