package egovframework.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * @title : util
 * @desc : TODO
 * @author : kwonsy
 * @date: 2014. 11. 28. 
 */
public  class util{
	
	public static List<?> COMMON_CD_LIST;	//공통(기타)코드
	public static List<?> BANK_CD_LIST;	//은행코드 리스트
	public static List<?> ERR_CD_LIST;		//오류코드 리스트

	public static HashMap<String, String> LANG_CD_LIST;	//다국어
	public static List<?> MENU_CD_LIST;	//메뉴

	/**
	 * @return the LANG_CD_LIST
	 */
	public static HashMap<String, String> getLANG_CD_LIST() {
		HashMap<String, String> list = LANG_CD_LIST;
		return list;
	}

	/**
	 * @param LANG_CD_LIST the LANG_CD_LIST to set
	 */
	public static void setLANG_CD_LIST(HashMap<String, String> langCdList) {
		LANG_CD_LIST = langCdList;
	}
	
	/**
	 * @return the MENU_CD_LIST
	 */
	public static List<?> getMENU_CD_LIST() {
		List<?> list = MENU_CD_LIST;
		return list;
	}

	/**
	 * @param MENU_CD_LIST the MENU_CD_LIST to set
	 */
	public static void setMENU_CD_LIST(List<?> menuCdList) {
		MENU_CD_LIST = menuCdList;
	}
	
	/**
	 * @return the cOMMON_CD_LIST
	 */
	public static List<?> getCOMMON_CD_LIST() {
		List<?> list = COMMON_CD_LIST;
		return list;
	}


	/**
	 * @param cOMMON_CD_LIST the cOMMON_CD_LIST to set
	 */
	public static void setCOMMON_CD_LIST(List<?> commonCdList) {
		COMMON_CD_LIST = commonCdList;
	}

	/**
	 * @return the bANK_CD_LIST
	 */
	public static List<?> getBANK_CD_LIST() {
		List<?> list = BANK_CD_LIST;
		return list;
	}


	/**
	 * @param bANK_CD_LIST the bANK_CD_LIST to set
	 */
	public static void setBANK_CD_LIST(List<?> bankCdList) {
		BANK_CD_LIST = bankCdList;
	}


	/**
	 * @return the eRR_CD_LIST
	 */
	public static List<?> getERR_CD_LIST() {
		List<?> list = ERR_CD_LIST;
		return list;
	}


	/**
	 * @param eRR_CD_LIST the eRR_CD_LIST to set
	 */
	public static void setERR_CD_LIST(List<?> errCdList) {
		ERR_CD_LIST = errCdList;
	}


	/**
	 * map을 json 형태로 반환
	 * @title : mapToJson
	 * @desc : TODO 
	 * @parameter : @param map
	 * @parameter : @return
	 * @returns : JSONObject
	 * @throws
	 */
	public static JSONObject mapToJson(HashMap<?, ?> map){
		JSONObject jsonObject = JSONObject.fromObject(map);
		return jsonObject;
	}
	
	
	/**
	 * list(HashMap)을 json array 으로 변환
	 * @title : mapToJson
	 * @desc : TODO 
	 * @parameter : @param list
	 * @parameter : @return
	 * @parameter : @
	 * @returns : JSONArray
	 * @throws
	 */
	public static JSONArray mapToJson(List<?> list){
		JSONArray jsList = JSONArray.fromObject(list);
		return jsList;
	}
	
	
	
	public static HashMap<String, String> jsonToMap(JSONObject jsonObject){
		HashMap<String, String> map = (HashMap<String, String>)JSONObject.toBean(jsonObject, HashMap.class);
		return map;
	}
	
	
	
	/**
	 * 좌측 공백제거
	 * @param str
	 * @return
	 */
	public static String ltrim(String str){
		if(str == null) str = "";
		str = str.replaceAll("^\\s+","");
		return str;
	}
	
	/**
	 * 우측 공백제거
	 * @param str
	 * @return
	 */
	public static String rtrim(String str){
		if(str == null) str = "";
		str = str.replaceAll("\\s+$","");
		return str;
	}
	
	/**
	 * 좌우측 공백제거
	 * @param str
	 * @return
	 */
	public static String trim(String str){
		if(str == null) str = "";
		str = str.replaceAll("^\\s+", "");
		return str;
	}
	
	/**
	 * null인경우 ""리턴
	 * @param str
	 * @return
	 */
	public static String null2void(String str){
		if(str == null) return "";
		return str;
	}
	
	/**
	 * null인경우 입력 str로 리턴
	 * @param str
	 * @param defStr
	 * @return
	 */
	public static String null2void(String str, String defStr){
		if(str == null || str.equals("")) return defStr;
		return str;
	}
	
	/**
	 * 빈값인지 확인 - null, 또는 좌우공백제거 후 비교
	 * @param str
	 * @return
	 */
	public static boolean isEmptyStr(String str){
		if(util.trim(str).equals("")) return true;
		return false;
	}
	
	/**
	 * 왼쪽에 입력길이 만큼 문자열(0) 추가
	 * @param str
	 * @param len
	 * @return
	 */
	public static String lpad(String str, int len){
		return lpad(str, len, "0");
	}
	
	/**
	 * 왼쪽에 입력길이 만큼 입력문자열 추가
	 * @param str
	 * @param len
	 * @param padStr
	 * @return
	 */
	public static String lpad(String str, int len, String padStr){
		str = util.null2void(str);
		int sLen = len - str.length();
		for(int i=0; i<sLen; i++){
			str = padStr + str;
		}
		
		return str;
	}
	
	
	/**
	 * 우측에 입력길이 만큼 문자열(0) 추가
	 * @param str
	 * @param len
	 * @return
	 */
	public static String rpad(String str, int len){
		return rpad(str, len, "0");
	}
	
	/**
	 * 우측에 입력길이 만큼 입력문자열 추가
	 * @param str
	 * @param len
	 * @param padStr
	 * @return
	 */
	public static String rpad(String str, int len, String padStr){
		str = util.null2void(str);
		int sLen = len - str.length();
		for(int i=0; i<sLen; i++){
			str = str + padStr;
		}
		
		return str;
	}
	
	
	/**
	 * clob을 String으로 변환
	 * @param clob
	 * @return
	 * @throws SQLException
	 * @throws IOException
	 */
	public static String clobToString(Clob clob) throws SQLException,  IOException {
		if (clob == null){
			return "";
		}

		StringBuffer strOut = new StringBuffer();
		String str = "";
		BufferedReader br = new BufferedReader(clob.getCharacterStream());
		try{
			while ((str = br.readLine()) != null) {
				strOut.append(str);
			}
			br.close();
		}catch (IOException io) {
			io.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		}catch(Exception e){
			return "";
		}finally{
			if(br != null) br.close();
		}
		
		
		return strOut.toString();
	}
	
	
	
	public static String getShortDateString()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd", Locale.KOREA);
		return formatter.format(new Date());
	}
	public static String getShortTimeString()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("HHmmss", Locale.KOREA);
		return formatter.format(new Date());
	}
	public static String getDateStampString()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
		return formatter.format(new Date());
	}
	public static String getTimeStampString()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss:SSS", Locale.KOREA);
		return formatter.format(new Date());
	}
	public static String getTimeString()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss", Locale.KOREA);
		return formatter.format(new Date());
	}
	public static String getDateTimeString(Date dt)
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		return formatter.format(dt);
	}
	public static String getTodayString()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		return formatter.format(new Date());
	}
	
	
	/**
	 * 암호화 sha 256 복화화 안됨.
	 * @param str
	 * @return
	 */
	public static String encrypt(String str) {
		if(str == null || str.equals("")) return "";
        try{
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(str.getBytes());
            byte byteData[] = md.digest();

            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }

            StringBuffer hexString = new StringBuffer();
            for (int i=0;i<byteData.length;i++) {
                String hex=Integer.toHexString(0xff & byteData[i]);
                if(hex.length()==1){
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        }catch (NullPointerException nu){
			nu.printStackTrace();
		}catch(Exception e){
			 throw new RuntimeException();
		}
    }
	
	
	
	/**
	*	반각문자를 전각 문자로 변환한다.
	* @param  src : 대치할 문자열
	* @return String : 대치될 문자열
	*/
	public static String toFullChar(String src){
		// 입력된 스트링이 null 이면 null 을 리턴
		if (src == null)     return null;
		// 변환된 문자들을 쌓아놓을 StringBuffer 를 마련한다
		StringBuffer strBuf = new StringBuffer();
		char c =0;
	
		for (int i = 0; i < src.length(); i++) {
			c = src.charAt(i) ;
	
			//영문이거나 특수 문자 일경우.
			if (c >= 0x21 && c <= 0x7e){
				c += 0xfee0;
			} else if (c == 0x20){
				c = 0x3000;
			}
	
			// 문자열 버퍼에 변환된 문자를 쌓는다
			strBuf.append(c) ;
		}
		return strBuf.toString();
	}
	
	
	
	
	/**
	*	전각문자를 반각 문자로 변경한다.
	* @param  src : 대치할 문자열
	* @return String : 대치될 문자열
	*/
	public static String toHalfChar(String src){
		if(src == null || src.equals("")) return "";
		
		StringBuffer strBuf = new StringBuffer();
		char c =0;
	
		for (int i = 0; i < src.length(); i++){
			c = src.charAt(i);
	
			//영문이거나 특수 문자 일경우.
			if (c >= 0xff01 && c <= 0xff5e) {
				c -= 0xfee0;
			} else if (c == 0x3000) {
				c = 0x20;
			}
	
			// 문자열 버퍼에 변환된 문자를 쌓는다
			strBuf.append(c);
		}
		return strBuf.toString();
	}
	
}
