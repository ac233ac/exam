package com.wzz.utils;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.ObjectMetadata;
import com.wzz.config.OSSConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * @author by wzz
 * @implNote 2020/10/26 10:25
 */
@Component
@RequiredArgsConstructor
public class OSSUtil {

    private final OSSConfig ossConfig;

    public String picOSS(MultipartFile uploadFile) throws Exception {
        if (!ossConfig.isEnable()) {
            return "";
        }
        // 创建OSSClient实例
        OSSClient ossClient = new OSSClient(ossConfig.getEndpoint(), ossConfig.getAccesskeyid(), ossConfig.getAccesskeysecret());
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        // 上传
        long time = new Date().getTime();
        String date = sf.format(time);

        //上传的文件名
        String fileName = UUID.randomUUID().toString().substring(0, 5) + uploadFile.getOriginalFilename();

        //设置请求头
        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(getcontentType(fileName.substring(fileName.lastIndexOf("."))));
        //上传开始
        ossClient.putObject(ossConfig.getBucketname(), ossConfig.getKey() + date + "/" + fileName, new ByteArrayInputStream(uploadFile.getBytes()), objectMetadata);

        // 关闭client
        ossClient.shutdown();
//        Date expiration = new Date(new Date().getTime() + 3600L * 1000 * 24 * 365 * 10);
//        return ossClient.generatePresignedUrl(BUCKETNAME, KEY + date + "/" + uploadFile.getOriginalFilename(), expiration).toString();
        return String.format("https://%s.%s/%s/%s", ossConfig.getBucketname(), ossConfig.getHost(), ossConfig.getKey() + date, fileName);
    }

    //根据文件的类型 设置请求头
    public static String getcontentType(String FilenameExtension) {
        if (FilenameExtension.equalsIgnoreCase(".bmp")) {
            return "image/bmp";
        }
        if (FilenameExtension.equalsIgnoreCase(".gif")) {
            return "image/gif";
        }
        if (FilenameExtension.equalsIgnoreCase(".jpeg") ||
                FilenameExtension.equalsIgnoreCase(".jpg") ||
                FilenameExtension.equalsIgnoreCase(".png")) {
            return "image/jpg";
        }
        if (FilenameExtension.equalsIgnoreCase(".html")) {
            return "text/html";
        }
        if (FilenameExtension.equalsIgnoreCase(".txt")) {
            return "text/plain";
        }
        if (FilenameExtension.equalsIgnoreCase(".vsd")) {
            return "application/vnd.visio";
        }
        if (FilenameExtension.equalsIgnoreCase(".pptx") ||
                FilenameExtension.equalsIgnoreCase(".ppt")) {
            return "application/vnd.ms-powerpoint";
        }
        if (FilenameExtension.equalsIgnoreCase(".docx") ||
                FilenameExtension.equalsIgnoreCase(".doc")) {
            return "application/msword";
        }
        if (FilenameExtension.equalsIgnoreCase(".xml")) {
            return "text/xml";
        }
        return "image/jpg";
    }
}
