package com.baizhi;


import com.baizhi.entity.Article;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Date;

@SpringBootTest(classes = EsApplication.class)
@RunWith(SpringRunner.class)
public class EsApplicationTests {
    @Autowired
    private BookRepository bookRespistory;

    @Test
    public void contextLoads() {
        Article book = new Article();
        book.setId("21");
        book.setTitle("好好");
        book.setTime(new Date());
        book.setAuthor("李白");
        book.setContent("这是中国的好人,这真的是一个很好的人,李白很狂");
        bookRespistory.save(book);

    }

}
