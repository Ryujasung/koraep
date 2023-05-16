package egovframework.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * sql injection cross script 방지
 * @title : XSSFilter
 * @desc : TODO
 * @author : kwonsy
 * @date: 2018. 1. 3.
 */
public class XSSFilter {
	private static final Logger log = LoggerFactory.getLogger(XSSFilter.class);
	
	//filter적용
	public static HashMap<String, String> setXSSFilter(HashMap<String, String> map){
		if(map == null) return null;
		List<String> keys = new ArrayList<String>();
		Iterator<String> it = map.keySet().iterator();
		while(it.hasNext()){
			keys.add((String)it.next());
		}
		return XSSFilter.setXSSFilter(map, keys);
	}
	
	public static HashMap<String, String> setXSSFilter(HashMap<String, String> map, List keys){
		if(map == null) return null;
		for(int i=0; i<keys.size(); i++){
			String key = (String)keys.get(i);
			String value =  map.get(key);
			value = XSSFilter.doFiltering(value);
			map.put(key, value);
		}
		return map;
	}
	
	
	
	public static Map setXSSFilter(Map<String, String> map){
		if(map == null) return null;
		List<String> keys = new ArrayList<String>();
		Iterator<String> it = map.keySet().iterator();
		while(it.hasNext()){
			keys.add((String)it.next());
		}
		return XSSFilter.setXSSFilter(map, keys);
	}
	
	//filter적용
	public static Map setXSSFilter(Map<String, String> map, List keys){
		if(map == null) return null;
		for(int i=0; i<keys.size(); i++){
			String key = (String)keys.get(i);
			String value =  map.get(key);
			value = XSSFilter.doFiltering(value);
			map.put(key, value);
		}
		return map;
	}
	
	
	public static ArrayList getXSSFilter(List rtnList, List keys) throws SQLException, IOException{
		ArrayList list = new ArrayList();
		if(rtnList == null || rtnList.size() == 0) return null;
		
		for(int i=0; i<rtnList.size(); i++){
			EgovMap map = (EgovMap)rtnList.get(i);
			if(keys == null) keys = map.keyList();
			
			for(int x=0; x<keys.size(); x++){
				String key = (String)keys.get(x);
				String value = "";
				if(map.get(key) instanceof java.sql.Clob){
					value = util.clobToString((java.sql.Clob) map.get(key));
				}else{
					value =  (String)map.get(key);
				}
				value = XSSFilter.charReplace(value);
				value = XSSFilter.undoFiltering(value);
				map.put(key, value);
			}
			list.add(map);
		}
		return list;
	}
	
	public static EgovMap getXSSFilter(EgovMap map, List keys) throws SQLException, IOException{
		if(map == null) return null;
		if(keys == null) keys = map.keyList();
		
		for(int x=0; x<keys.size(); x++){
			String key = (String)keys.get(x);
			String value = "";
			if(map.get(key) instanceof java.sql.Clob){
				value = util.clobToString((java.sql.Clob) map.get(key));
			}else{
				value =  (String)map.get(key);
			}
			value = XSSFilter.charReplace(value);
			value = XSSFilter.undoFiltering(value);
			map.put(key, value);
		}
		return map;
	}
	
	//editor에서 사용한 태그 처리
	public static String getFilter(String value){
		if(value == null || value.equals("")) return "";
		value = XSSFilter.charReplace(value);
        value = XSSFilter.undoFiltering(value);
		return value;
	}
	
	
	//editor에서 사용한 태그 처리
	public static String charReplace(String value){
		if(value == null) return "";
		value = value.replaceAll("&lt;","<"); 
	    value = value.replaceAll("&gt;",">"); 
	    //value = value.replaceAll("&nbsp;"," "); 
	    value = value.replaceAll("&amp;","&"); 
	    value = value.replaceAll("&quot;","\"");
	    return value;
	}
	

	
    /**
     * SQL Injection Attack과 크로스스크립트 Attack을 막기 위해 사용.
     * @param s   사용자로부터 입력받은 폼값.
     * @return       특수문자로 변환된 문자열.
     */
    public static String doFiltering(String s)
    {
    	if(s == null) return s;

        s = changeString(s, "<", "&#60;");
        s = changeString(s, "--", "");
//        s = changeString(s, ">", "&#62;");
        s = changeString(s, "'", "&#39;");
        s = changeString(s, "\"", "&#34;");
        s = changeString(s, "..", "&#46;&#46;");
        //s = changeString(s, "/", "&#47;");
        //s = changeString(s, "(", "&#40;");
        //s = changeString(s, ")", "&#41;");
        s = changeString(s, "{", "&#123;");
        s = changeString(s, "}", "&#125;");
        s = changeString(s, "\\", "&#92;");
        //s = changeString(s, "?", "&#63;");
        s = changeString(s, "%", "&#37;");
        //s = changeString(s, "+", "&#43;");
        s = allReplaceToIgnoreCase(s, "SCRIPT", "scrpt");
        s = allReplaceToIgnoreCase(s, "IFRAME", "ifrme");
/*
        s = changeString(s, "Script", "&#83;&#99;&#114;&#105;&#112;&#116;");
        s = changeString(s, "iframe", "&#105;&#102;&#114;&#97;&#109;&#101;");
        s = changeString(s, "Iframe", "&#73;&#102;&#114;&#97;&#109;&#101;");
        s = changeString(s, "IFrame", "&#73;&#70;&#114;&#97;&#109;&#101;");
*/
        s = changeString(s, "xmp", "&#120;&#109;&#112;");
        s = changeString(s, "drop table", "&#100;&#114;&#111;&#112;&#28;&#116;&#97;&#98;&#108;&#101;");
        s = changeString(s, "delete from", "&#100;&#101;&#108;&#101;&#116;&#101;&#28;&#102;&#114;&#111;&#109;");
        s = changeString(s, "create table", "&#99;&#114;&#101;&#97;&#116;&#101;&#28;&#116;&#97;&#98;&#108;&#101;");
        s = changeString(s, "DROP TABLE", "&#100;&#114;&#111;&#112;&#28;&#116;&#97;&#98;&#108;&#101;");
        s = changeString(s, "DELETE FROM", "&#100;&#101;&#108;&#101;&#116;&#101;&#28;&#102;&#114;&#111;&#109;");
        s = changeString(s, "CREATE TABLE", "&#99;&#114;&#101;&#97;&#116;&#101;&#28;&#116;&#97;&#98;&#108;&#101;");

        return s;
    }


    /**
     * doFiltering에 의해 변환된 문자열을 원래 문자로 되돌린다.
     * @param s 특수문자로 변환된 문자열
     * @return 원복된 문자열
     */
    public static String undoFiltering(String s)
    {
        s = changeString(s, "&#60;", "<");
        s = changeString(s, "&#62;", ">");
        s = changeString(s, "&#39;", "'");
        s = changeString(s, "&#34;", "\"");
        s = changeString(s, "&#46;&#46;", "..");
        s = changeString(s, "&#47;", "/");
        s = changeString(s, "&#40;", "(");
        s = changeString(s, "&#41;", ")");
        s = changeString(s, "&#123;", "{");
        s = changeString(s, "&#125;", "}");
        s = changeString(s, "&#92;", "\\");
        s = changeString(s, "&#63;", "?");
        s = changeString(s, "&#37;", "%");
        s = changeString(s, "&#43;", "+");

        s = allReplaceToIgnoreCase(s, "SCRIPT", "scrpt");
        s = allReplaceToIgnoreCase(s, "IFRAME", "ifrme");

        //s = changeString(s, "&#115;&#99;&#114;&#105;&#112;&#116;", "script");
        //s = changeString(s, "&#83;&#67;&#82;&#73;&#80;&#84;", "SCRIPT");
        //s = changeString(s, "&#83;&#99;&#114;&#105;&#112;&#116;", "Script");
        s = changeString(s, "&#105;&#102;&#114;&#97;&#109;&#101;", "iframe");
        s = changeString(s, "&#120;&#109;&#112;", "xmp");
        s = changeString(s, "&#100;&#114;&#111;&#112;&#28;&#116;&#97;&#98;&#108;&#101;", "drop table");
        s = changeString(s, "&#100;&#101;&#108;&#101;&#116;&#101;&#28;&#102;&#114;&#111;&#109;", "delete from");
        s = changeString(s, "&#99;&#114;&#101;&#97;&#116;&#101;&#28;&#116;&#97;&#98;&#108;&#101;", "create table" );

        return s;
    }

    private static String replace(String s, String s1, String s2)
    {
        if(s == null)
            return null;
        StringBuffer stringbuffer = new StringBuffer("");
        int i = s1.length();
        int j = s.length();
        int k;
        int l;
        for(l = 0; (k = s.indexOf(s1, l)) >= 0; l = k + i)
        {
            stringbuffer.append(s.substring(l, k));
            stringbuffer.append(s2);
        }

        if(l < j)
            stringbuffer.append(s.substring(l, j));
        return stringbuffer.toString();
    }

    private static String changeString(String s, String s1, String s2)
    {
        return replace(s, s1, s2);
    }

    public static String allReplaceToIgnoreCase(String str, String compStr, String sepStr) {
        String ret = "";
        if ( null == str || "".equals(str.trim()) )
            return "";
        String tempStr = str.toUpperCase();
        int cutLength = 0;
        int compMax = compStr.length();
        int strLength = str.length();
        int compLength = tempStr.indexOf(compStr);
        int tempStrLen = tempStr.length();
        
        while(tempStr.indexOf(compStr) > -1){
        	compLength = tempStr.indexOf(compStr);
            tempStrLen = tempStr.length();
            ret += str.substring(cutLength, cutLength + compLength) + sepStr;
            tempStr = tempStr.substring(compLength + compMax, tempStrLen);
            cutLength = cutLength + compLength + compMax;
        }
        /*
        for(int i=0; tempStr.indexOf(compStr) > -1; i++) {
        	compLength = tempStr.indexOf(compStr);
            tempStrLen = tempStr.length();
            ret += str.substring(cutLength, cutLength + compLength) + sepStr;
            tempStr = tempStr.substring(compLength + compMax, tempStrLen);
            cutLength = cutLength + compLength + compMax;
        }
        */
        if(compLength < 0) {
            ret = str;
        }else {
            ret += str.substring(cutLength, strLength);
        }
        return ret;
    }

    /**
     * SQL Injection Attack과 크로스스크립트 Attack을 막기 위해 사용.
     * @param str   사용자로부터 입력받은 폼값.
     * @return      int (문자 입력시 0을 리턴)
     */
    public static int doFilteringInt(String str) {
        int strInt = 0;
        try {
            strInt = Integer.parseInt(str);
        }catch ( NumberFormatException e ) {
        	log.debug(" numberformat exception");
        }

        return strInt;
    }

    /**
     * SQL Injection Attack과 크로스스크립트 Attack을 막기 위해 사용.
     * @param str   사용자로부터 입력받은 폼값.
     * @return      int (문자 입력시 tar을 리턴, ""일 경우는 0을 리턴)
     */
    public static int doFilteringInt(String str, int tar) {
        int strInt = 0;
        if ( str == null || "".equals(str) )
            return strInt;
        try {
            strInt = Integer.parseInt(str);
        }catch ( NumberFormatException e ) {
            strInt = tar;
        }

        return strInt;
    }
}
