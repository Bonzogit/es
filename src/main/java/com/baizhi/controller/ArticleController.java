package com.baizhi.controller;

import com.baizhi.entity.Article;
import com.baizhi.serivce.ArticleService;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.QueryStringQueryBuilder;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("article")
public class ArticleController {
    @Autowired
    ArticleService articleService;
    @Autowired
    TransportClient transportClient;

    @RequestMapping("add")
    @ResponseBody
    public void add(Article article) throws IOException {
        articleService.add(article);
    }

    @RequestMapping("search")
    @ResponseBody
    public List<Map<String, Object>> search(String param) throws UnknownHostException {
//        TransportClient transportClient = new PreBuiltTransportClient(Settings.EMPTY).addTransportAddress(transportAddress);
        QueryStringQueryBuilder queryStringQueryBuilder =
                QueryBuilders.queryStringQuery(param)
                        .analyzer("ik_max_word") //定义分词器
                        .field("title")//定义字段
                        .field("author")//定义字段
                        .field("content");//字段

        HighlightBuilder highlightBuilder = new HighlightBuilder();
        highlightBuilder.requireFieldMatch(false).field("author").field("title").field("content").preTags("<span style='color:red'>").postTags("</span>");

        SearchResponse searchResponse = transportClient.prepareSearch("article").setTypes("book").highlighter(highlightBuilder).highlighter(highlightBuilder).setQuery(queryStringQueryBuilder).get();
        SearchHits hits = searchResponse.getHits();
        List<Map<String, Object>> list = new ArrayList<>();
        for (SearchHit hit : hits) {


            Map<String, Object> sourceAsMap = hit.getSourceAsMap();
            System.out.println(sourceAsMap.get("id"));

            Map<String, HighlightField> highlightFields = hit.getHighlightFields();
            for (String s : highlightFields.keySet()) {
                sourceAsMap.put(s, highlightFields.get(s).getFragments()[0].toString());
            }

            list.add(sourceAsMap);

        }

        return list;
    }
}
