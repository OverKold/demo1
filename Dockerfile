# ---- 构建阶段：用 Maven 打出 war ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q clean package

# ---- 运行阶段：Tomcat 10（匹配你的 jakarta.* 代码）----
FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/demo1-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
# Hugging Face Space 要求应用监听 7860 端口，改 Tomcat 的 Connector
RUN sed -i 's/port="8080"/port="7860"/' /usr/local/tomcat/conf/server.xml
EXPOSE 7860
CMD ["catalina.sh", "run"]