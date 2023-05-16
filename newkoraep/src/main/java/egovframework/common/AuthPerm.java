package egovframework.common;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * com.ReadPerm.java
 *
 * @Description : 읽기 권한에 대한 어노테이션
 * @Author   : JCJ
 * @Version   : 1.0
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface AuthPerm {
   String value();
}

