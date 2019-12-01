package com.baizhi.conf;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.text.SimpleDateFormat;

@Component
public class ScheduledTasks {
    //    @Autowired
//    ArticleService articleService;
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");

    //  @Scheduled(fixedRate = 5000)
    public void reportCurrentTime() throws IOException {

//      articleService.update();
    }
}
