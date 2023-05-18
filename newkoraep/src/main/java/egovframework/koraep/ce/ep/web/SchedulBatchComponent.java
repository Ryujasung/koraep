package egovframework.koraep.ce.ep.web;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;







import org.springframework.web.client.RestTemplate;

import com.orsoncharts.util.json.JSONArray;
import com.orsoncharts.util.json.JSONObject;
import com.orsoncharts.util.json.parser.JSONParser;
import com.orsoncharts.util.json.parser.ParseException;

import egovframework.koraep.ce.ep.service.EPCE0140199Service;
import egovframework.mapper.ce.ep.EPCE0140199Mapper;
import egovframework.mapper.ce.ep.EPCE9000601Mapper;





























//--------------------
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.SQLException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@EnableScheduling
// @Component
@Controller
public class SchedulBatchComponent {
	private static final Log logger = LogFactory.getLog(SchedulBatchComponent.class);
	@Autowired
	private ApplicationContext context;
	
	@Resource(name="epce0140199Mapper")
	private EPCE0140199Mapper epce0140199Mapper;
	
	@Resource(name="epce9000601Mapper")
	private EPCE9000601Mapper epce9000601Mapper;
	
	@Resource(name="epce0140199Service")
	private EPCE0140199Service epce0140199Service;
	
	//@Scheduled(fixedRateString = "30000")
	@Scheduled(cron="0 0 06 * * ? ")
	public void SchedulBatch() throws ParseException {
		long format_time1 = System.currentTimeMillis();
		System.out.println("오전6시휴면계정이메일전송");
		logger.debug(format_time1);
		logger.debug("hello SchedulBatch");
		//====================휴면계정 이메일 전송 시작=====================
		Map<String, Object> data = new HashMap<String, Object>();
		try {
    		epce0140199Mapper.epce0140199_merge2();
				//throw new Exception("A001");
				
				
				
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e1) {
			// TODO Auto-generated catch block
/*			e1.printStackTrace();*/
			//취약점점검 6282 기원우 
		} // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		
		List<?> menuList = epce0140199Mapper.epce0140199_select2(data);
//		data.put("list", menuList); 
		
		if(menuList != null && menuList.size() > 0){
			System.out.println("데이터있음");
			try {
				for(int i=0;i < menuList.size(); i++){
					Map map = (HashMap)menuList.get(i);
					epce0140199Service.epce0140199_mail2(map);
		
				}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				/*e1.printStackTrace();*/
				//취약점점검 6311 기원우
			}
		}else{
			System.out.println("데이터없음");
		}
		
		//====================휴면계정 이메일 전송 끝=====================

		
		//====================톰라API 연동시=====================
		
		/*String appKey = "KakaoAK 8ed5767e7e3ab4b645d614771189b6be"; //API KEY
		String apiURL = "https://dapi.kakao.com/v2/search/web?sort=accuracy&page=1&size=10&query=%EA%B9%80%EC%83%81%EC%A4%91";
		
		RestTemplate restTemplate = new RestTemplate(); 

		HttpHeaders headers = new HttpHeaders(); 
		headers.setContentType(MediaType.APPLICATION_JSON);//JSON 변환 
		headers.set("Authorization", appKey); //appKey 설정 ,KakaoAK kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk 이 형식 준수

		HttpEntity entity = new HttpEntity("parameters", headers); 
		URI url=URI.create(apiURL); 
		//x -> x좌표, y -> y좌표 
		System.out.println("########3@@@@@@");
		ResponseEntity response= restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
		//String 타입으로 받아오면 JSON 객체 형식으로 넘어옴
		System.out.println("########4@@@@@@");
		JSONParser jsonParser = new JSONParser(); 
		JSONObject jsonObject = (JSONObject) jsonParser.parse(response.getBody().toString());
		//저는 Body 부분만 사용할거라 getBody 후 JSON 타입을 인자로 넘겨주었습니다
		//헤더도 필요하면 getBody()는 사용할 필요가 없음
		
		//JSONParser jsonParser = new JSONParser();
		JSONArray docuArray = (JSONArray) jsonObject.get("documents");
		//documents만 뽑아오고  
		System.out.println("########5@@@@@@"+docuArray.size());
		for(int i = 0 ; docuArray.size() > i ; i++){
			JSONObject docuObject = (JSONObject) docuArray.get(i); 
			//배열 i번째 요소 불러오고
			         
			logger.info(docuObject.get("contents").toString());
			//뽑아오기 원하는 Key 이름을 넣어주면 그 value가 반환된다.
			System.out.println("########6@@@@@@"+docuObject.get("contents").toString().substring(1, 10));
			String tmp = docuObject.get("contents").toString().substring(1, 10);
			
			
			//회수량보증금 단가로 회수용기코드 추출
			int rtn_gtn = 10000;
			int rtn_qty = 100;
			int result = rtn_gtn/rtn_qty;
			String cpct_cd = "";
			if(result == 70){
				cpct_cd = "13";
			}else if(result == 100){
				cpct_cd = "23";
			}else if(result == 130){
				cpct_cd = "33";
			}else if(result == 350){
				cpct_cd = "43";
			}
			
			
			Map<String, String> map = new HashMap<String, String>();
			map.put("SERIAL_NO", tmp);
			//톰라api로 받아온 데이터입력
			epce9000601Mapper.tomra_data_insert(map);
		}*/
		//=========================================
		
		//==================json 데이터로 테스트start=======================
		/*System.out.println("########json 데이터로 테스트start@@@@@@");
		JSONParser parser = new JSONParser();
		try {
			Object obj;
			System.out.println("########1@@@@@@");
			obj = parser.parse(new FileReader("C:/Temp/TOMRA-Testdata.json"));
			System.out.println("########2@@@@@@");
			JSONObject jo = (JSONObject) obj;
			System.out.println("########3@@@@@@");
			JSONArray docuArray = (JSONArray) jo.get("data");
			System.out.println("########4@@@@@@");
			//System.out.println(jo.get("JDBCDriver"));
			
			System.out.println("########5@@@@@@"+ docuArray.size());
			for(int i = 0 ; docuArray.size() > i ; i++){
				Map<String, String> map = new HashMap<String, String>();
				
				JSONObject docuObject = (JSONObject) docuArray.get(i);
				//배열 i번째 요소 불러오고
				System.out.println("########44@@@@@@"+ docuObject.get("machine"));
				//JSONArray docuArray3 = (JSONArray) docuObject.get("machine");
				//JSONObject docuObject3 = (JSONObject) docuArray3.get(0); 
				System.out.println("########444serial@@@@@@"+ ((Map) docuObject.get("machine")).get("serial"));
				map.put("SERIAL_NO", (String) ((Map) docuObject.get("machine")).get("serial"));
				JSONArray docuArray2 = (JSONArray) docuObject.get("items");
				System.out.println("########55@@@@@@"+ docuArray2.size());
				if(docuArray2.size() > 1){
					for(int x = 0 ; docuArray2.size() > x ; x++){
						JSONObject docuObject2 = (JSONObject) docuArray2.get(i); 
						System.out.println("########77@@@@@@"+ docuObject2.get("barcode"));
						System.out.println("########88@@@@@@"+ docuObject2.get("reject"));
						map.put("BARCODE_NO", (String) docuObject2.get("barcode"));
						map.put("RTN_GTN", (String) docuObject2.get("reject"));
						epce9000601Mapper.tomra_data_insert(map);
					}
				}else{
					System.out.println("########99@@@@@@"+docuArray2.get(0));
					JSONObject docuObject3 = (JSONObject) docuArray2.get(0); 
					System.out.println("########10@@@@@@"+ docuObject3.get("barcode"));
					map.put("BARCODE_NO", (String) docuObject3.get("barcode"));
					map.put("RTN_GTN", (String)  docuObject3.get("reject"));
					epce9000601Mapper.tomra_data_insert(map);
				}
				//logger.info(docuObject.get("serial").toString());
				//뽑아오기 원하는 Key 이름을 넣어주면 그 value가 반환된다.
				//System.out.println("########6@@@@@@"+docuObject.get("serial"));
			}
			
			
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        
		
		System.out.println("########json 데이터로 테스트end@@@@@@");*/
		//==================json 데이터로 테스트end========================
		
		
		//----------------------------------------------------
//		String clientId = "YOUR_CLIENT_ID";//애플리케이션 클라이언트 아이디값";
//        String clientSecret = "YOUR_CLIENT_SECRET";//애플리케이션 클라이언트 시크릿값";
//	        try {
//	            String text = URLEncoder.encode("안녕하세요. 오늘 기분은 어떻습니까?", "UTF-8");
//	            String apiURL = "https://openapi.naver.com/v1/papago/n2mt";
//	            URL url = new URL(apiURL);
//	            HttpURLConnection con = (HttpURLConnection)url.openConnection();
//	            con.setRequestMethod("POST");
//	            con.setRequestProperty("X-Naver-Client-Id", clientId);
//	            con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
//	            // post request
//	            String postParams = "source=ko&target=en&text=" + text;
//	            con.setDoOutput(true);
//	            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
//	            wr.writeBytes(postParams);
//	            wr.flush();
//	            wr.close();
//	            int responseCode = con.getResponseCode();
//	            BufferedReader br;
//	            if(responseCode==200) { // 정상 호출
//	                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
//	            } else {  // 에러 발생
//	                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
//	            }
//	            String inputLine;
//	            StringBuffer response = new StringBuffer();
//	            while ((inputLine = br.readLine()) != null) {
//	                response.append(inputLine);
//	            }
//	            br.close();
//	            System.out.println("########2@@@@@@");
//	            System.out.println(response.toString());
//	            System.out.println("########3@@@@@@");
//	        } catch (Exception e) {
//	            System.out.println(e);
//	        }
		//-------------------------------------------------------

		long format_time2 = System.currentTimeMillis();
		logger.debug(format_time1);
		long elapsedTime = format_time1 - format_time2;
		logger.debug(elapsedTime);
		

//		Object clsTs = context.getBean("BatchTestComponent");
		//Class cls = clsTs.getClass();
		   
		//bean.getClass()
		try {
			//Object clsInstance = cls.newInstance();
//			Method doMethod = clsTs.getClass().getMethod("getTest");
//			doMethod.invoke(clsTs);
		
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {		
			/*e.printStackTrace();*/
			//취약점점검 6286 기원우
		}
		/*
		BatchTestComponent batchTestComponent = new BatchTestComponent();
		batchTestComponent.getTest();
		*/
		List<String> jobPaths = new ArrayList<String>();
/*
		Class<?> cls;
		try {
			cls = Class.forName("org.kpc.lms.batch.BatchTestComponent");
			Object obj = cls.newInstance();
			
			Method doMethod = obj.getClass().getMethod("getTest");
			doMethod.invoke(obj);
			//obj.getClass().
			
			//Method setIdMethod = obj.getClass().getMethod("getTest", String.class);
			
		} catch (Exception e) {		
			e.printStackTrace();
		}
*/
		/*
		 * 1. SAM 실행 예제(File To File)에서 사용 할 Batch Job이 기술 된 xml파일 경로들((jobPaths)
		 */
		jobPaths.add("/egovframework/batch/job/delimitedToDelimitedJob.xml");
		jobPaths.add("/egovframework/batch/job/fixedToFixedJob.xml");

		/*
		 * 2. SAM 실행 예제(File To DB)에서 사용 할 Batch Job이 기술 된 xml파일 경로들((jobPaths)
		 */
		jobPaths.add("/egovframework/batch/job/fixedToIbatisJob.xml");
		jobPaths.add("/egovframework/batch/job/fixedToJdbcJob.xml");
		// scheduler.schedule(task, new CronTrigger("* 15 9-17 * * MON-FRI"));
		/*
		 * EgovSchedulerRunner에 contextPath, schedulerJobPath, jobPaths를 인수로 넘겨서 실행한다.
		 * contextPath: Batch Job 실행에 필요한 context 정보가 기술된 xml파일 경로 schedulerJobPath:
		 * Scheduler의 Trigger가 수행할 SchedulerJob(ex: QuartzJob)이 기술된 xml파일 경로 jobPaths:
		 * Batch Job이 기술 된 xml 파일 경로들 delayTime: Scheduler 실행을 위해 ApplicationContext를
		 * 종료를 지연시키는 시간(실행시간) (기본 30000 milliseconds: 30초)
		 */
		// EgovSchedulerRunner egovSchedulerRunner = new EgovSchedulerRunner(
		// "/egovframework/batch/context-batch-scheduler.xml",
		// "/egovframework/batch/context-scheduler-job.xml",
		// jobPaths, 30000);
		// egovSchedulerRunner.start();

	}

}
