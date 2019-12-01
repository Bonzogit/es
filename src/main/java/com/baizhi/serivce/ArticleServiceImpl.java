package com.baizhi.serivce;

import com.baizhi.dao.ArticleDao;
import com.baizhi.entity.Article;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.update.UpdateResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class ArticleServiceImpl implements ArticleService {
    @Autowired
    ArticleDao articleDao;
    @Autowired
    TransportClient transportClient;

    @Override
    public void add(Article article) throws IOException {
        String id = UUID.randomUUID().toString();
        article.setId(id);
        Date date = new Date();
        article.setTime(date);
        articleDao.add(article);
        XContentBuilder xContentBuilder = XContentFactory.jsonBuilder().startObject()

                .field("title", article.getTitle())
                .field("author", article.getAuthor())
                .field("time", article.getTime())
                .field("content", article.getContent()).endObject();
        IndexResponse indexResponse = transportClient.prepareIndex("article", "book", article.getId()).setSource(xContentBuilder).get();

    }

    @Override
    @Scheduled(cron = "0/10 * * * * *")
    public void update() throws IOException {
        List<Article> all = articleDao.findAll();
        int i = 0;
        for (Article article : all) {
            System.out.println(article + "****" + i++);
            XContentBuilder source = XContentFactory.jsonBuilder();
            source.startObject()
                    .field("title", article.getTitle())
                    .field("author", article.getAuthor())
                    .field("content", article.getContent())

                    .endObject();
            UpdateResponse updateResponse = transportClient.prepareUpdate("article", "book", article.getId())
                    .setDoc(source).get();

        }
    }

}
