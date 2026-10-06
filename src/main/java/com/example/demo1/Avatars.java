package com.example.demo1;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/** 头像白名单：仅允许这 25 张成员立绘，防止任意路径注入。ChatServlet / OnlineServlet 共用 */
public final class Avatars {
    private Avatars() {}
    private static final Set<String> ALLOW = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList(
            "Mygo/anon.png", "Mygo/soyo.png", "Mygo/tomori.png", "Mygo/riki.png", "Mygo/rana.png",
            "AveMujica/Saki.jpg", "AveMujica/htn.jpg", "AveMujica/meow.jpg", "AveMujica/mtm.jpg", "AveMujica/tmls.jpg",
            "MewType/arl.jpg", "MewType/nnk.jpg", "MewType/ricu.jpg", "MewType/tdz.jpg", "MewType/yuno.jpg",
            "Millsage/hotaru.jpg", "Millsage/houka.jpg", "Millsage/mahoro.jpg", "Millsage/nagi.jpg", "Millsage/natsume.jpg",
            "一家Dumbrock/chieri.jpg", "一家Dumbrock/miku.jpg", "一家Dumbrock/raika.jpg", "一家Dumbrock/shizuku.jpg", "一家Dumbrock/yomogi.jpg"
    )));
    /** 合法返回原值，非法/空返回 null */
    public static String norm(String av) {
        if (av == null) return null;
        av = av.trim();
        return ALLOW.contains(av) ? av : null;
    }
}