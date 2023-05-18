package egovframework.common;

import java.io.Closeable;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Wrapper;

/**
 * Utility class  to support to close resources
 * @author Vincent Han
 * @since 2014.09.18
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일        수정자       수정내용
 *  -------       --------    ---------------------------
 *   2014.09.18	표준프레임워크센터	최초 생성
 *
 * </pre>
 */
public class EgovResourceCloseHelper {
	/**
	 * Resource close 처리.
	 * @param resources
	 */
	public static void close(Closeable  ... resources) {
		for (Closeable resource : resources) {
			if (resource != null) {
				try {
					resource.close();
				} catch (IOException io ) {
					EgovBasicLogger.ignore("Occurred Exception to close resource is ingored!!");
				} catch (Exception e) {
					e.getMessage();
				}
			}
		}
	}
	
	/**
	 * JDBC 관련 resource 객체 close 처리
	 * @param objects
	 */
	public static void closeDBObjects(Wrapper ... objects) {
		for (Object object : objects) {
			if (object != null) {
				if (object instanceof ResultSet) {
					try {
						((ResultSet)object).close();
					} catch (SQLException ex ) {
						EgovBasicLogger.ignore("Occurred Exception to close resource is ingored!!");
					} catch (Exception e) {
						e.getMessage();
					}
				} else if (object instanceof Statement) {
					try {
						((Statement)object).close();
					} catch (SQLException ex) {
						EgovBasicLogger.ignore("Occurred Exception to close resource is ingored!!");
					} catch (Exception e) {
						e.getMessage();
					}
				} else if (object instanceof Connection) {
					try {
						((Connection)object).close();
					} catch (SQLException ex) {
						EgovBasicLogger.ignore("Occurred Exception to close resource is ingored!!");
					} catch (Exception e) {
						e.getMessage();
					}
				} else {
					throw new IllegalArgumentException("Wrapper type is not found : " + object.toString());
				}
			}
		}
	}
	
	/**
	 * Socket 관련 resource 객체 close 처리
	 * @param objects
	 */
	public static void closeSocketObjects(Socket socket, ServerSocket server) {
		if (socket != null) {
			try {
				socket.shutdownOutput();
			} catch (SocketException ex) {
				EgovBasicLogger.ignore("Occurred Exception to shutdown ouput is ignored!!");
			} catch (Exception e) {
				e.getMessage();
			}
			
			try {
				socket.close();
			} catch (SocketException ex) {
				EgovBasicLogger.ignore("Occurred Exception to shutdown ouput is ignored!!");
			} catch (Exception e) {
				e.getMessage();
			}
		}
		
		if (server != null) {
			try {
				server.close();
			} catch (SocketException ex) {
				EgovBasicLogger.ignore("Occurred Exception to shutdown ouput is ignored!!");
			} catch (Exception e) {
				e.getMessage();
			}
		}
	}
	
	/**
	 *  Socket 관련 resource 객체 close 처리
	 *  
	 * @param sockets
	 */
	public static void closeSockets(Socket ... sockets) {
		for (Socket socket : sockets) {
			if (socket != null) {
				try {
					socket.shutdownOutput();
				} catch (SocketException ex) {
					EgovBasicLogger.ignore("Occurred Exception to shutdown ouput is ignored!!");
				} catch (Exception e) {
					e.getMessage();
				}
				
				try {
					socket.close();
				} catch (SocketException ex) {
					EgovBasicLogger.ignore("Occurred Exception to shutdown ouput is ignored!!");
				} catch (Exception e) {
					e.getMessage();
				}
			}
		}
	}
}