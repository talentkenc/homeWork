package com.biz.lesson.util;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.*;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import java.util.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.logging.Logger;

public class AliOssClient {
    //private static final Logger LOGGER = LoggerFactory.getLogger(AliOssClient.class);

    private String accessKeyId;
    private String accessKeySecret;
    private String endpoint;

    public String getAccessKeyId() {
        return accessKeyId;
    }

    public void setAccessKeyId(String accessKeyId) {
        this.accessKeyId = accessKeyId;
    }

    public String getAccessKeySecret() {
        return accessKeySecret;
    }

    public void setAccessKeySecret(String accessKeySecret) {
        this.accessKeySecret = accessKeySecret;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }
    /**
     * 上传某个Object
     * @param resourceHost
     * @param key
     * @param inputStream
     * @return
     */
    public PutObjectResult putObject(String resourceHost, String key, InputStream inputStream, String contentType) {
        OSSClient client = new OSSClient(this.endpoint, this.accessKeyId, this.accessKeySecret);
        PutObjectResult result = null;
        try {
            // 创建上传Object的Metadata
            ObjectMetadata meta = new ObjectMetadata();
            // 设置文件类型
            meta.setContentType(contentType);
            // 上传Object.
            result = client.putObject(resourceHost, key, inputStream, meta);
            //
        } catch (Exception e) {
            //LOGGER.error("exception threw while putObject. resourceHost={}, key={}",
                    //resourceHost, key, e);
            return result;
        }
        return result;
    }

    /**
     * 获取某个Object
     * @param resourceHost
     * @param key
     * @throws IOException
     */
    public InputStream getObject(String resourceHost, String key) throws IOException {
        // 初始化OSSClient
        OSSClient client = new OSSClient(endpoint, accessKeyId, accessKeySecret);
        InputStream objectContent = null;
        try {
            // 获取Object，返回结果为OSSObject对象
            OSSObject object = client.getObject(resourceHost, key);
            // 获取Object的输入流
            objectContent = object.getObjectContent();
            // 处理Object
            // 关闭流
            // objectContent.close();
            return objectContent;
        } catch (Exception e) {
           // LOGGER.error("exception threw while getObject. resourceHost={}, key={}, exception={}",
                 //   resourceHost, key, e);
            return objectContent;
        }
    }

    /**
     * 分片上传MultipartUpload
     * @param resourceHost
     * @param key
     * @param
     * @return
     */
    public String uploadFile(String resourceHost,String key,MultipartFile partFile)throws IOException {
        OSSClient client = new OSSClient(this.endpoint, this.accessKeyId, this.accessKeySecret);
        return multipartUpload(key,partFile,client,resourceHost);

    }


    private String multipartUpload(String key, MultipartFile partFile, OSSClient client, String bucketName) throws IOException {
        // 开始Multipart Upload
        InitiateMultipartUploadRequest initiateMultipartUploadRequest = new InitiateMultipartUploadRequest(bucketName, key);
        InitiateMultipartUploadResult initiateMultipartUploadResult = client.initiateMultipartUpload(initiateMultipartUploadRequest);
        final int partSize = 1024 * 1024 * 5;
        // 计算分块数目
        int partCount = (int) (partFile.getSize() / partSize);
        if (partFile.getSize() % partSize != 0){
            partCount++;
        }
        // 新建一个List保存每个分块上传后的ETag和PartNumber
        List<PartETag> partETags = new ArrayList<>();
        for(int i = 0; i < partCount; i++){
            // 获取文件流
            InputStream fis = partFile.getInputStream();
            // 跳到每个分块的开头
            long skipBytes =(long) partSize * i;
            fis.skip(skipBytes);

            // 计算每个分块的大小
            long size = partSize < partFile.getSize() - skipBytes ?
                    partSize : partFile.getSize() - skipBytes;
            // 创建UploadPartRequest，上传分块
            UploadPartRequest uploadPartRequest = new UploadPartRequest();
            uploadPartRequest.setBucketName(bucketName);
            uploadPartRequest.setKey(key);
            uploadPartRequest.setUploadId(initiateMultipartUploadResult.getUploadId());
            uploadPartRequest.setInputStream(fis);
            uploadPartRequest.setPartSize(size);
            uploadPartRequest.setPartNumber(i + 1);
            UploadPartResult uploadPartResult = client.uploadPart(uploadPartRequest);
            // 将返回的PartETag保存到List中。
            partETags.add(uploadPartResult.getPartETag());
            // 关闭文件
            fis.close();
        }
        CompleteMultipartUploadRequest completeMultipartUploadRequest =
                new CompleteMultipartUploadRequest(bucketName,key, initiateMultipartUploadResult.getUploadId(), partETags);
        // 完成分块上传
        CompleteMultipartUploadResult completeMultipartUploadResult =
                client.completeMultipartUpload(completeMultipartUploadRequest);
        // 获得地址
        return completeMultipartUploadResult.getKey();

    }
}

