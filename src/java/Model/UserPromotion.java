/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.security.Timestamp;

/**
 *
 * @author ConMeowMeow
 */
public class UserPromotion {
    private long userPromotionId;

    private int userId;
    private int promotionId;

    private String status;

    private Timestamp receivedAt;
    private Timestamp usedAt;

    private Integer orderId;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    public UserPromotion() {
    }

    public UserPromotion(long userPromotionId, int userId, int promotionId, String status, Timestamp receivedAt, Timestamp usedAt, Integer orderId, Timestamp createdAt, Timestamp updatedAt) {
        this.userPromotionId = userPromotionId;
        this.userId = userId;
        this.promotionId = promotionId;
        this.status = status;
        this.receivedAt = receivedAt;
        this.usedAt = usedAt;
        this.orderId = orderId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public long getUserPromotionId() {
        return userPromotionId;
    }

    public void setUserPromotionId(long userPromotionId) {
        this.userPromotionId = userPromotionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(Timestamp receivedAt) {
        this.receivedAt = receivedAt;
    }

    public Timestamp getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
}
