package vn.greenglobal.cfgserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class CfgserverApplication {

    public static void main(String[] args) {
        SpringApplication.run(CfgserverApplication.class, args);
    }

}
