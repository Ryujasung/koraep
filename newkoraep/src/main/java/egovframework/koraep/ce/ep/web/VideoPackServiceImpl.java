///*
// * Copyright 2008-2009 the original author or authors.
// * 
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//package egovframework.koraep.ce.ep.web;
//
//import java.io.BufferedReader;
//import java.io.File;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.OutputStream;
//import java.io.OutputStreamWriter;
//import java.io.PrintWriter;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.nio.charset.StandardCharsets;
//import java.nio.file.Paths;
//import java.util.Map;
//import java.util.UUID;
//
//import javax.annotation.Resource;
//import javax.net.ssl.HttpsURLConnection;
//
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//import org.apache.http.HttpEntity;
//import org.apache.http.client.ClientProtocolException;
//import org.apache.http.client.ResponseHandler;
//import org.apache.http.client.methods.HttpUriRequest;
//import org.apache.http.client.methods.RequestBuilder;
//import org.apache.http.entity.ContentType;
//import org.apache.http.entity.mime.HttpMultipartMode;
//import org.apache.http.entity.mime.MultipartEntityBuilder;
//import org.apache.http.impl.client.CloseableHttpClient;
//import org.apache.http.impl.client.HttpClients;
//import org.apache.http.util.EntityUtils;
//import org.json.simple.JSONArray;
//import org.json.simple.JSONObject;
//import org.json.simple.parser.JSONParser;
//import org.json.simple.parser.ParseException;
//import org.kpc.lms.core.exception.LmsException;
//import org.kpc.lms.core.exception.LmsResultCode;
//import org.kpc.lms.core.util.StrUtil;
//import org.kpc.lms.sc.wecandeo.VideoPackService;
//import org.springframework.stereotype.Service;
//
//import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
//import egovframework.rte.fdl.property.EgovPropertyService;
//
///**
// * @Class Name : EgovSampleServiceImpl.java
// * @Description : Sample Business Implement Class
// * @Modification Information
// * @
// *
// * 	@author 개발프레임웍크 실행환경 개발팀
// * @since 2009. 03.16
// * @version 1.0
// * @see
// * 
// * 		Copyright (C) by MOPAS All right reserved.
// */
//
//@Service("videoPackService")
//public class VideoPackServiceImpl extends EgovAbstractServiceImpl implements VideoPackService {
//	private static final Log logger = LogFactory.getLog(VideoPackServiceImpl.class);
//
//	/** EgovPropertyService */
//	@Resource(name = "propertiesService")
//	protected EgovPropertyService propertiesService;
//
//	@Override
//	public void videoUpload(Map<String, Object> parameters) {
//		try {
//			String tempPath = Paths.get(propertiesService.getString("uploadInsideTempFilePath")).toString();
//
//			JSONParser jsonParser = new JSONParser();
//			JSONObject jsonObject = null;
//			JSONArray uploadName = null;
//			JSONArray uploadPath = null;
//			JSONArray extension = null;
//			JSONArray originalName = null;
//			JSONArray fileSize = null;
//
//			if (null != parameters.get("upFiles") && !"".equals(parameters.get("upFiles"))) {
//				jsonObject = (JSONObject) jsonParser.parse((String) parameters.get("upFiles"));
//				uploadName = (JSONArray) jsonObject.get("uploadName");
//				uploadPath = (JSONArray) jsonObject.get("uploadPath");
//				extension = (JSONArray) jsonObject.get("extension");
//				originalName = (JSONArray) jsonObject.get("originalName");
//				fileSize = (JSONArray) jsonObject.get("size");
//				for (int i = 0; i < uploadName.size(); i++) {
//					logger.debug("uploadName === " + uploadName.get(i));
//					logger.debug("uploadPath === " + uploadPath.get(i));
//					logger.debug("extension === " + extension.get(i));
//					logger.debug("originalName === " + originalName.get(i));
//					logger.debug("fileSize === " + fileSize.get(i));
//				}
//			}
//
//			
//			logger.debug("[------------------- 1.업로드 토큰 생성 ---------------------]");
//			String wecandeoapikey = propertiesService.getString("wecandeoapikey");
//			String wecandeoapiuploadToken = propertiesService.getString("wecandeoapiuploadToken");
//			String wecandeoapiuploadTokenUrl = wecandeoapiuploadToken.replaceAll("\\{API key\\}", wecandeoapikey);
//			logger.debug("wecandeoapiuploadTokenUrl === " + wecandeoapiuploadTokenUrl);
//
//			CloseableHttpClient httpclient = HttpClients.createDefault();
//
//			HttpUriRequest request = RequestBuilder.post(wecandeoapiuploadTokenUrl)
//					// .setEntity(data)
//					.build();
//			ResponseHandler<String> responseHandler = response -> {
//				int status = response.getStatusLine().getStatusCode();
//				if (status >= 200 && status < 300) {
//					HttpEntity entity = response.getEntity();
//					return entity != null ? EntityUtils.toString(entity) : null;
//				} else {
//					throw new ClientProtocolException("Unexpected response status: " + status);
//				}
//			};
//			
//			String responseBody = httpclient.execute(request, responseHandler);
//			logger.debug("----------------------------------------");
//			logger.debug(responseBody);
//
//			jsonObject = (JSONObject) jsonParser.parse(responseBody);
//			JSONObject resInfo = (JSONObject) jsonObject.get("uploadInfo");
//
//			JSONObject errorInfo = (JSONObject) resInfo.get("errorInfo");
//			String errorCode = (String) errorInfo.get("errorCode");
//			if (!"None".equals(errorCode)) {
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//			}
//			
//			//String uuid = UUID.randomUUID().toString();
//			File sendFile = new File(Paths.get(tempPath, uploadName.get(0).toString()).toString());
//			
//			//File uuidDIr = new File(Paths.get(tempPath, UUID.randomUUID().toString()).toString());
//			//uuidDIr.mkdir();
//			//File uuidSendFile = new File(Paths.get(tempPath, UUID.randomUUID().toString()).toString());					
//			//sendFile.renameTo(uuidSendFile);
//			
//			logger.debug("[------------------- 2.파일업로드 ---------------------]");
//			String uploadUrl = (String) resInfo.get("uploadUrl");
//			String uploadToken = (String) resInfo.get("token");
//			String originaFileName = (String) originalName.get(0);
//			MultipartEntityBuilder meb = MultipartEntityBuilder.create().setCharset(StandardCharsets.UTF_8);			 
//			meb.setMode(HttpMultipartMode.BROWSER_COMPATIBLE); 			
//			meb.addBinaryBody("upfile", sendFile, ContentType.DEFAULT_BINARY, originaFileName);
//			meb.addTextBody("folder", "2011681");
//			meb.addTextBody("pkg", "1013523");
//			HttpEntity data = meb.build();
//			request = RequestBuilder.post(uploadUrl + "?token=" + uploadToken)
//					.setEntity(data)
//					.build();
//			
//			responseHandler = response -> {
//				int status = response.getStatusLine().getStatusCode();
//				if (status >= 200 && status < 300) {
//					HttpEntity entity = response.getEntity();
//					return entity != null ? EntityUtils.toString(entity) : null;
//				} else {
//					throw new ClientProtocolException("Unexpected response status: " + status);
//				}
//			};
//			
//			responseBody = httpclient.execute(request, responseHandler);
//			logger.debug("----------------------------------------");
//			logger.debug(responseBody);
//
//			jsonObject = (JSONObject) jsonParser.parse(responseBody);
//			resInfo = (JSONObject) jsonObject.get("uploadInfo");
//
//			errorInfo = (JSONObject) resInfo.get("errorInfo");
//			errorCode = (String) errorInfo.get("errorCode");
//			if (!"None".equals(errorCode)) {
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//			} 
//			JSONObject uploadDetail = (JSONObject) resInfo.get("uploadDetail");
//			String accessKey = (String) uploadDetail.get("access_key");
//			
//			while(true){
//				request = RequestBuilder.post( uploadUrl+"/uploadStatus.json?token="+uploadToken).build();
//				responseHandler = response -> {
//					int status = response.getStatusLine().getStatusCode();
//					if (status >= 200 && status < 300) {
//						HttpEntity entity = response.getEntity();
//						return entity != null ? EntityUtils.toString(entity) : null;
//					} else {
//						throw new ClientProtocolException("Unexpected response status: " + status);
//					}
//				};
//				responseBody = httpclient.execute(request, responseHandler);
//				logger.debug(responseBody);
//				jsonObject = (JSONObject) jsonParser.parse(responseBody);
//				
//				if("100".equals(jsonObject.get("process").toString())) {
//					break;
//				}
//				try {
//					Thread.sleep(5000);
//				} catch (InterruptedException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				
//			}
//			
//			
//			while(true){
//				request = RequestBuilder.post( uploadUrl+"/status.json?token="+uploadToken).build();
//				responseHandler = response -> {
//					int status = response.getStatusLine().getStatusCode();
//					if (status >= 200 && status < 300) {
//						HttpEntity entity = response.getEntity();
//						return entity != null ? EntityUtils.toString(entity) : null;
//					} else {
//						throw new ClientProtocolException("Unexpected response status: " + status);
//					}
//				};
//				responseBody = httpclient.execute(request, responseHandler);
//				logger.debug(responseBody);
//				jsonObject = (JSONObject) jsonParser.parse(responseBody);
//				try {
//					if("COMPLETE".equals(jsonObject.get("status").toString())) {
//						Thread.sleep(5000);
//						break;
//					}
//				
//					Thread.sleep(5000);
//				} catch (InterruptedException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				
//			}
//			
//			
//			logger.debug("[------------------- 4.자막 업로드  ---------------------]");
//			if(1==2) { // 자막이 존재 한다면
//				uploadUrl = uploadUrl + "?token=" + uploadToken;
//				meb = MultipartEntityBuilder.create().setCharset(StandardCharsets.UTF_8);			 
//				meb.setMode(HttpMultipartMode.BROWSER_COMPATIBLE); 			
//				meb.addBinaryBody("upfile", sendFile, ContentType.DEFAULT_BINARY, (String) originalName.get(0));
//				meb.addTextBody("folder", "2011681");
//				meb.addTextBody("pkg", "1013523");
//				data = meb.build();
//				request = RequestBuilder.post(uploadUrl)
//						.setEntity(data)
//						.build();
//				
//				responseHandler = response -> {
//					int status = response.getStatusLine().getStatusCode();
//					if (status >= 200 && status < 300) {
//						HttpEntity entity = response.getEntity();
//						return entity != null ? EntityUtils.toString(entity) : null;
//					} else {
//						throw new ClientProtocolException("Unexpected response status: " + status);
//					}
//				};
//			}
//			
//			logger.debug("[------------------- 3.배포 상태조회  ---------------------]");
//			String publishStatusUrl = "https://api.wecandeo.com/info/v1/video/publishInfo.json?key="+wecandeoapikey+"&access_key="+accessKey+"&pkg=1013523";
//			//String videoKey = "";
//			JSONArray videoFileList = null;
//			Boolean videoService = true;
//			while(true){
//				videoService = true;
//				request = RequestBuilder.post( publishStatusUrl).build();
//				responseHandler = response -> {
//					int status = response.getStatusLine().getStatusCode();
//					if (status >= 200 && status < 300) {
//						HttpEntity entity = response.getEntity();
//						return entity != null ? EntityUtils.toString(entity) : null;
//					} else {
//						throw new ClientProtocolException("Unexpected response status: " + status);
//					}
//				};
//				responseBody = httpclient.execute(request, responseHandler);
//				logger.debug(responseBody);
//				jsonObject = (JSONObject) jsonParser.parse(responseBody);
//				resInfo = (JSONObject) jsonObject.get("videoPublishInfo");
//				
//				errorInfo = (JSONObject) resInfo.get("errorInfo");
//				errorCode = (String) errorInfo.get("errorCode");
//				if (!"None".equals(errorCode)) {
//					throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//				} 
//				
//				try {
//					
//					videoFileList = (JSONArray) resInfo.get("videoFileList");
//					for(int i=0; i < videoFileList.size(); i++) {
//						if(!"SERVICE".equals(((JSONObject) videoFileList.get(i)).get("status").toString())) {					
//							videoService = false;
//						}
//					}					
//					
//					if(videoService) {					
//						break;
//					}				
//					Thread.sleep(5000);
//				} catch (InterruptedException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				
//			}
//			
//			
//			/*
//			logger.debug("[------------------- 3.인코딩 상태조회  ---------------------]");
//			String statusUrl = "https://api.wecandeo.com/web/encoding/status.json?key="+wecandeoapikey+"&access_key="+accessKey+"&pkg=1013523";
//			logger.debug("[--인코딩 상태조회  --url ]="+statusUrl);
//			request = RequestBuilder.post(statusUrl).build();			
//			
//			responseHandler = response -> {
//				int status = response.getStatusLine().getStatusCode();
//				if (status >= 200 && status < 300) {
//					HttpEntity entity = response.getEntity();
//					return entity != null ? EntityUtils.toString(entity) : null;
//				} else {
//					throw new ClientProtocolException("Unexpected response status: " + status);
//				}
//			};
//			
//			responseBody = httpclient.execute(request, responseHandler);
//			logger.debug("----------------------------------------");
//			logger.debug(responseBody);
//
//			jsonObject = (JSONObject) jsonParser.parse(responseBody);
//			resInfo = (JSONObject) jsonObject.get("encodingStatus");
//
//			errorInfo = (JSONObject) resInfo.get("errorInfo");
//			errorCode = (String) errorInfo.get("errorCode");
//			if (!"None".equals(errorCode)) {
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//			} 
//			JSONObject videoPublishInfo = (JSONObject) resInfo.get("videoPublishInfo");
//			String videoKey = (String) videoPublishInfo.get("videoKey");
//			*/
//			
//			//https://api.wecandeo.com/info/v1/video/detail.json?key={API key}&access_key={access_key}&pkg={package ID}
//		
//			logger.debug("[------------------- 동영상 상세정보 조회  ---------------------]");
//			String detailUrl = "https://api.wecandeo.com/info/v1/video/detail.json?key="+wecandeoapikey+"&access_key="+accessKey+"&pkg=1013523";
//			logger.debug("[--동영상 상세정보 조회  --url ]="+detailUrl);
//			request = RequestBuilder.post(detailUrl).build();			
//			
//			responseHandler = response -> {
//				int status = response.getStatusLine().getStatusCode();
//				if (status >= 200 && status < 300) {
//					HttpEntity entity = response.getEntity();
//					return entity != null ? EntityUtils.toString(entity) : null;
//				} else {
//					throw new ClientProtocolException("Unexpected response status: " + status);
//				}
//			};
//			
//			responseBody = httpclient.execute(request, responseHandler);
//			logger.debug("----------------------------------------");
//			logger.debug(responseBody);
//
//			jsonObject = (JSONObject) jsonParser.parse(responseBody);
//			resInfo = (JSONObject) jsonObject.get("videoDetail");
//
//			errorInfo = (JSONObject) resInfo.get("errorInfo");
//			errorCode = (String) errorInfo.get("errorCode");
//			if (!"None".equals(errorCode)) {
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//			} 
//			Map<String, Object> videoDetail = StrUtil.getMapFromJsonObject((JSONObject) resInfo.get("videoInfo"));
//			
//			
//			videoDetail.put("originaFileName", originaFileName);
//			
//			
//			//return videoDetail;
//			//{"uploadInfo":{"uploadDetail":{"duration":301100,"video_height":360,"access_key":"lU6DgfisvmwACCyfgUEFSisMSl2jH2jpLj3dRjpV6VfeEie","video_width":480,"video_framerate":29.97},"errorInfo":{"errorCode":"None","errorMessage":""}}}
//			//https://api.wecandeo.com/info/v1/video/publishInfo.json?key={API key}&access_key={access_key}&pkg={package id}
//			parameters.put("videoDetail", videoDetail);
//		} catch (ParseException | IOException e) {
//			// TODO Auto-generated catch block
//			// e.printStackTrace();
//			throw new LmsException(LmsResultCode.ETC_EXCEPTION, e);
//		}
//
//	}
//	
////	@Override
////	public void videoList(Map<String, Object> parameters) {
////		
////	}
////	
////	@Override
////	public void videoEncodeList(Map<String, Object> parameters) {
////		
////	}
//	
//	public void videoUpload2(Map<String, Object> parameters) {
//
//		String boundary = "^-----^" + UUID.randomUUID().toString();
//		String LINE_FEED = "\r\n";
//		String charset = "UTF-8";
//		try {
//			String tempPath = Paths.get(propertiesService.getString("uploadInsideTempFilePath")).toString();
//
//			JSONParser jsonParser = new JSONParser();
//			JSONObject jsonObject = null;
//			JSONArray uploadName = null;
//			JSONArray uploadPath = null;
//			JSONArray extension = null;
//			JSONArray originalName = null;
//			JSONArray fileSize = null;
//
//			if (null != parameters.get("upFiles") && !"".equals(parameters.get("upFiles"))) {
//				jsonObject = (JSONObject) jsonParser.parse((String) parameters.get("upFiles"));
//				uploadName = (JSONArray) jsonObject.get("uploadName");
//				uploadPath = (JSONArray) jsonObject.get("uploadPath");
//				extension = (JSONArray) jsonObject.get("extension");
//				originalName = (JSONArray) jsonObject.get("originalName");
//				fileSize = (JSONArray) jsonObject.get("size");
//				for (int i = 0; i < uploadName.size(); i++) {
//					logger.debug("uploadName === " + uploadName.get(i));
//					logger.debug("uploadPath === " + uploadPath.get(i));
//					logger.debug("extension === " + extension.get(i));
//					logger.debug("originalName === " + originalName.get(i));
//					logger.debug("fileSize === " + fileSize.get(i));
//				}
//			}
//
//			File sendFile = new File(Paths.get(tempPath, uploadName.get(0).toString()).toString());
//
//			String wecandeoapikey = propertiesService.getString("wecandeoapikey");
//			String wecandeoapiuploadToken = propertiesService.getString("wecandeoapiuploadToken");
//			String wecandeoapiuploadTokenUrl = wecandeoapiuploadToken.replaceAll("\\{API key\\}", wecandeoapikey);
//			logger.debug("wecandeoapiuploadTokenUrl === " + wecandeoapiuploadTokenUrl);
//
//			URL url = new URL(wecandeoapiuploadTokenUrl);
//			HttpsURLConnection urlcon = (HttpsURLConnection) url.openConnection();
//			StringBuffer sb = new StringBuffer();
//
//			int responseCode = urlcon.getResponseCode();
//			if (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_CREATED) {
//				BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getInputStream(), "UTF-8"));
//				String inputLine;
//				while ((inputLine = in.readLine()) != null) {
//					sb.append(inputLine);
//				}
//				in.close();
//			} else {
//				BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getErrorStream()));
//				String inputLine;
//				StringBuffer response = new StringBuffer();
//				while ((inputLine = in.readLine()) != null) {
//					response.append(inputLine);
//				}
//				in.close();
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, response.toString());
//			}
//			logger.debug("sb 토큰 정보가져오기  === " + sb.toString());
//			jsonObject = (JSONObject) jsonParser.parse(sb.toString());
//			JSONObject uploadInfo = (JSONObject) jsonObject.get("uploadInfo");
//
//			JSONObject errorInfo = (JSONObject) uploadInfo.get("errorInfo");
//			String errorCode = (String) errorInfo.get("errorCode");
//			if (!"None".equals(errorCode)) {
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//			}
//
//			String uploadUrl = (String) uploadInfo.get("uploadUrl");
//			String uploadToken = (String) uploadInfo.get("token");
//			// uploadUrl = uploadUrl + "?token="+ uploadToken;
//			uploadUrl = uploadUrl + "?token=" + uploadToken;
//			// uploadUrl = uploadUrl + "&folder=2011677";
//			// uploadUrl = uploadUrl + "&title="+originalName.get(0);
//
//			logger.debug("uploadUrl === " + uploadUrl);
//
//			url = new URL(uploadUrl);
//			urlcon = (HttpsURLConnection) url.openConnection();
//			// 읽기와 쓰기 모두 가능하게 설정
//			urlcon.setDoInput(true);
//			urlcon.setDoOutput(true);
//			urlcon.setUseCaches(false);
//
//			// POST타입으로 설정
//			urlcon.setRequestMethod("POST");
//
//			// Map<String,Object> params = new LinkedHashMap<>(); // 파라미터 세팅
//			// params.put("name", "james");
//			// params.put("email", "james@example.com");
//			// params.put("reply_to_thread", 10394);
//			// params.put("message", "Hello World");
//
//			// StringBuilder postData = new StringBuilder();
//			// postData.append('&');
//			// postData.append(URLEncoder.encode("", "UTF-8"));
//			// postData.append('=');
//			// postData.append(URLEncoder.encode("atservice", "UTF-8"));
//			// byte[] postDataBytes = postData.toString().getBytes("UTF-8");
//
//			// 헤더 설정
//			urlcon.setRequestProperty("Connection", "Keep-Alive");
//			urlcon.setRequestProperty("content-type", "application/x-www-form-urlencoded");
//			urlcon.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);
//			OutputStream outputStream = urlcon.getOutputStream();
//
//			StringBuffer buffer = new StringBuffer();
//			buffer.append("folder").append("=").append("2011677");
//
//			// Output스트림을 열어
//			// DataOutputStream dos = new DataOutputStream(urlcon.getOutputStream());
//			PrintWriter writer = new PrintWriter(new OutputStreamWriter(urlcon.getOutputStream(), charset), true);
//			writer.write(buffer.toString());
//			writer.flush();
//
//			// dos.writeBytes("token="+URLEncoder.encode(uploadToken,"UTF-8"));
//			// dos.writeBytes("&folder="+URLEncoder.encode("2011683","UTF-8"));
//
//			/** Body에 데이터를 넣어줘야 할경우 없으면 Pass **/
//			// writer.append("--" + boundary).append(LINE_FEED);
//			// writer.append("Content-Disposition: form-data;
//			// name=\"token\"").append(LINE_FEED);
//			// writer.append("Content-Type: text/plain; charset=" +
//			// charset).append(LINE_FEED);
//			// writer.append(LINE_FEED);
//			// writer.append(uploadToken).append(LINE_FEED);
//			// writer.flush();
//
//			// dos.writeBytes("--" + boundary);
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes("Content-Disposition: form-data; name=\"token\"");
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes("Content-Type: text/plain; charset=" + charset);
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes(uploadToken);
//			// dos.writeBytes(LINE_FEED);
//
//			// dos.writeBytes("--" + boundary + LINE_FEED);
//			// dos.writeBytes("Content-Disposition: form-data; name=\"token\"" + LINE_FEED);
//			// dos.writeBytes("Content-Type: text/plain; charset=UTF-8" + LINE_FEED);
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes(URLEncoder.encode(uploadToken,"UTF-8")+LINE_FEED);
//
//			// dos.writeBytes("--" + fileuuid + LINE_FEED);
//			// dos.writeBytes("Content-Disposition: form-data; name=\"folder\"" +
//			// LINE_FEED);
//			// dos.writeBytes("Content-Type: text/plain; charset=UTF-8" + LINE_FEED);
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes("2011683"+LINE_FEED);
//
//			// dos.writeBytes("--" + fileuuid + LINE_FEED);
//			// dos.writeBytes("Content-Disposition: form-data;
//			// name=\"videofile\";filename=\""+ originalName.get(0) +"\"" + LINE_FEED);
//			// dos.writeBytes(LINE_FEED);
//			//
//			// FileInputStream fileInputStream = new FileInputStream(sendFile);
//			//
//			// //버퍼사이즈를 설정하여 buffer할당
//			// int bytesAvailable = fileInputStream.available();
//			// int maxBufferSize = 1024;
//			// int bufferSize = Math.min(bytesAvailable, maxBufferSize);
//			// byte[] buffer = new byte[bufferSize];
//			//
//			// //스트림에 작성
//			// int bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//			// while (bytesRead > 0)
//			// {
//			// // Upload file part(s)
//			// dos.write(buffer, 0, bufferSize);
//			// bytesAvailable = fileInputStream.available();
//			// bufferSize = Math.min(bytesAvailable, maxBufferSize);
//			// bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//			// }
//			// dos.writeBytes(LINE_FEED);
//			// dos.writeBytes("--" + fileuuid + "--" + LINE_FEED);
//			// fileInputStream.close();
//
//			// /** 파일 데이터를 넣는 부분**/
//			// writer.append("--" + boundary).append(LINE_FEED);
//			// writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"" +
//			// originalName.get(0) + "\"").append(LINE_FEED);
//			// //writer.append("Content-Type: " +
//			// URLConnection.guessContentTypeFromName(sendFile.getName())).append(LINE_FEED);
//			// writer.append("Content-Type: " +
//			// Files.probeContentType(sendFile.toPath())).append(LINE_FEED);
//			//
//			// writer.append("Content-Transfer-Encoding: binary").append(LINE_FEED);
//			// writer.append(LINE_FEED);
//			// writer.flush();
//			//
//			// FileInputStream inputStream = new FileInputStream(sendFile);
//			// byte[] buffer = new byte[(int)sendFile.length()];
//			// int bytesRead = -1;
//			// while ((bytesRead = inputStream.read(buffer)) != -1) {
//			// outputStream.write(buffer, 0, bytesRead);
//			// }
//			// outputStream.flush();
//			// inputStream.close();
//			// writer.append(LINE_FEED);
//			// writer.flush();
//			//
//			// writer.append("--" + boundary + "--").append(LINE_FEED);
//
//			writer.close();
//			// 써진 버퍼를 stream에 출력.
//			// dos.flush();
//
//			/*
//			 * 
//			 * writer.append("--" + boundary).append(LINE_FEED);
//			 * writer.append("Content-Disposition: form-data; name=\""+name+"\"").append(
//			 * LINE_FEED); writer.append("Content-Type: text/plain; charset=" +
//			 * charset).append(LINE_FEED); writer.append(LINE_FEED);
//			 * writer.append(value).append(LINE_FEED); writer.flush();
//			 * 
//			 * urlcon.getOutputStream().write(postDataBytes); // POST 호출
//			 */
//			// 전송. 결과를 수신.
//			responseCode = urlcon.getResponseCode();
//			if (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_CREATED) {
//				BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getInputStream(), "UTF-8"));
//				String inputLine;
//
//				InputStream is = urlcon.getInputStream();
//				sb = new StringBuffer();
//				while ((inputLine = in.readLine()) != null) {
//					sb.append(inputLine);
//				}
//				in.close();
//				logger.debug("sb 토큰 정보가져오기  === " + sb.toString());
//				jsonObject = (JSONObject) jsonParser.parse(sb.toString());
//				uploadInfo = (JSONObject) jsonObject.get("uploadInfo");
//				errorInfo = (JSONObject) uploadInfo.get("errorInfo");
//				errorCode = (String) errorInfo.get("errorCode");
//				if (!"None".equals(errorCode)) {
//					throw new LmsException(LmsResultCode.ETC_EXCEPTION, errorInfo.get("errorMessage").toString());
//				}
//
//			} else {
//				BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getErrorStream()));
//				String inputLine;
//				StringBuffer response = new StringBuffer();
//				while ((inputLine = in.readLine()) != null) {
//					response.append(inputLine);
//				}
//				in.close();
//				throw new LmsException(LmsResultCode.ETC_EXCEPTION, response.toString());
//			}
//
//		} catch (ParseException | IOException e) {
//			// TODO Auto-generated catch block
//			// e.printStackTrace();
//			throw new LmsException(LmsResultCode.ETC_EXCEPTION, e);
//		}
//
//	}
//
//	public String httpConnection(String targetUrl) {
//		URL url = null;
//		HttpURLConnection conn = null;
//		String jsonData = "";
//		BufferedReader br = null;
//		StringBuffer sb = null;
//		String returnText = "";
//
//		try {
//			url = new URL(targetUrl);
//
//			conn = (HttpURLConnection) url.openConnection();
//			conn.setRequestProperty("Accept", "application/json");
//			conn.setRequestMethod("GET");
//			conn.connect();
//
//			br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
//
//			sb = new StringBuffer();
//
//			while ((jsonData = br.readLine()) != null) {
//				sb.append(jsonData);
//			}
//
//			returnText = sb.toString();
//
//		} catch (IOException e) {
//			e.printStackTrace();
//		} finally {
//			try {
//				if (br != null)
//					br.close();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
//
//		return returnText;
//	}
//
//	// CloseableHttpClient httpClient = HttpClients.createDefault();
//	// HttpPost uploadFile = new HttpPost("...");
//	// MultipartEntityBuilder builder = MultipartEntityBuilder.create();
//	// builder.addTextBody("field1", "yes", ContentType.TEXT_PLAIN);
//	//
//	// // This attaches the file to the POST:
//	// File f = new File("[/path/to/upload]");
//	// builder.addBinaryBody(
//	// "file",
//	// new FileInputStream(f),
//	// ContentType.APPLICATION_OCTET_STREAM,
//	// f.getName()
//	// );
//	//
//	// HttpEntity multipart = builder.build();
//	// uploadFile.setEntity(multipart);
//	// CloseableHttpResponse response = httpClient.execute(uploadFile);
//	// HttpEntity responseEntity = response.getEntity();
//
//}
