/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.koraep.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class XSSRequestWrapper extends HttpServletRequestWrapper {

    private final static Logger log = LoggerFactory.getLogger(XSSRequestWrapper.class);

    private static Pattern[] patterns = null;

    public static synchronized void initPatterns(String[] regexes, String[] flags) {
        if (regexes == null || regexes.length == 0) {
            log.error("Error: Empty XSS Regex array provided from jetspeed.properties");
            return;
        }
        if (flags == null || flags.length == 0) {
            log.error("Error: Empty XSS Regex Flag array provided from jetspeed.properties");
            return;
        }
        if (regexes.length != flags.length) {
            log.error("XSS Regex and flag arrays not equal in jetspeed.properties");
            return;
        }
        patterns = new Pattern[regexes.length];
        int ix = 0;
        for (String regex : regexes) {
            try {
                String[] values = flags[ix].split("\\s*\\|\\s*");
                int orFlags = 0;
                for (String value : values) {
                    orFlags |= Integer.parseInt(value);
                }
                if (log.isDebugEnabled()) {
                    log.debug(String.format("--- adding pattern: [%s] with flags %d\n", regex, orFlags));
                }
                patterns[ix] = Pattern.compile(regex, orFlags);
            }catch (IOException io) {
            	System.out.println(io.toString());
            }catch (SQLException sq) {
            	System.out.println(sq.toString());
            }catch (NullPointerException nu){
            	System.out.println(nu.toString());
            }
            catch (Exception e) {
                log.error("Failed to compile regex: " + regex, e);
            }
            finally {
                ix++;
            }

        }
    }

    private static Pattern[] hardCodedPatterns = new Pattern[]{
            // Script fragments
            Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE),
            // src='...'
//            Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
//            Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
//            // lonely script tags
            Pattern.compile("</script>", Pattern.CASE_INSENSITIVE),
            Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
//            // eval(...)
//            Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
//            // expression(...)
//            Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
//            // javascript:...
            Pattern.compile("script", Pattern.CASE_INSENSITIVE),
            Pattern.compile("xmp", Pattern.CASE_INSENSITIVE),
            Pattern.compile("drop table", Pattern.CASE_INSENSITIVE),
            Pattern.compile("create table", Pattern.CASE_INSENSITIVE),
            Pattern.compile("insert into", Pattern.CASE_INSENSITIVE),
            Pattern.compile("delete from", Pattern.CASE_INSENSITIVE),
            
            Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
//            // vbscript:...
            Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE),
//            // onload(...)=...
            Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL)
    };

    public XSSRequestWrapper(HttpServletRequest servletRequest) {
        super(servletRequest);
    }

    @Override
    public String[] getParameterValues(String parameter) {
        String[] values = super.getParameterValues(parameter);

        if (values == null) {
            return null;
        }

        if (values.length == 0) {
            return values;
        }

        int count = values.length;
        String[] encodedValues = new String[count];
        for (int i = 0; i < count; i++) {
            encodedValues[i] = stripXSS(values[i]);
        }

        return encodedValues;
    }

    @Override
    public String getParameter(String parameter) {
        String value = super.getParameter(parameter);
        if (value == null) {
            return value;
        }
        return stripXSS(value);
    }

    @Override
    public Map<String, String[]> getParameterMap() {
        Map<String, String[]> parameterMap = super.getParameterMap();
        if (parameterMap == null) {
            return parameterMap;
        }
        if (parameterMap.size() == 0) {
            return parameterMap;
        }
        Iterator<String> parameterIterator = parameterMap.keySet().iterator();
        Map<String, String[]> newMap = new LinkedHashMap<String, String[]>();
        while (parameterIterator.hasNext()) {
            String key = parameterIterator.next().toString();
            String[] values = parameterMap.get(key);
            if (values != null) {
                String[] newValues = new String[values.length];
                for (int i = 0; i < values.length; i++) {
                    newValues[i] = stripXSS(values[i]);
                }
                newMap.put(key, newValues);
            }
        }
        return newMap;
    }

    //    @Override
//    public String getHeader(String name) {
//        String value = super.getHeader(name);
//        return stripXSS(value);
//    }

    private String stripXSS(String value) {

		if(value == null || value.equals("")) return value;
		
		// Avoid null characters
		value = value.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
		value = value.replaceAll("script", "");
		value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		value = value.replaceAll("alert", "");
        String original = value;
        // Remove all sections that match a pattern
        if (hardCodedPatterns != null) {
            for (Pattern scriptPattern : hardCodedPatterns) {
                //int length = value.length();
                value = scriptPattern.matcher(value).replaceAll("");
//                if (value.length() != length) {
//                    log.error("XSS attack post data found: " + original);
//                }
            }
        }
        
        return value;
    }
}