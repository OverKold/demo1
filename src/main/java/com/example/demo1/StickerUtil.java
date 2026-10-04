package com.example.demo1;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * 判断图片是否为"动图"——按真实内容(magic bytes + 帧)而非文件后缀。
 * 覆盖：真 GIF、被改名成 .jpg/.png 的 GIF、APNG、动画 WebP。
 */
public final class StickerUtil {
    private StickerUtil() {}

    private static final int SCAN_LIMIT = 512 * 1024; // 最多扫描 512KB

    public static boolean isAnimated(File f) {
        if (f == null || !f.isFile()) return false;
        try {
            return isAnimated(readCapped(f, SCAN_LIMIT));
        } catch (IOException e) {
            return false;
        }
    }

    static boolean isAnimated(byte[] d) {
        if (d == null || d.length < 12) return false;
        // GIF: "GIF87a"/"GIF89a"，多帧才算动图
        if (d[0] == 'G' && d[1] == 'I' && d[2] == 'F' && d[3] == '8') {
            return countGifFrames(d) > 1;
        }
        // PNG: 89 50 4E 47 ...，含 acTL 块即 APNG(动画)
        if ((d[0] & 0xFF) == 0x89 && d[1] == 'P' && d[2] == 'N' && d[3] == 'G') {
            return indexOfSeq(d, new byte[]{'a', 'c', 'T', 'L'}) >= 0;
        }
        // WEBP: RIFF....WEBP，含 ANIM/ANMF 块即动画
        if (d[0] == 'R' && d[1] == 'I' && d[2] == 'F' && d[3] == 'F'
                && d[8] == 'W' && d[9] == 'E' && d[10] == 'B' && d[11] == 'P') {
            return indexOfSeq(d, new byte[]{'A', 'N', 'I', 'M'}) >= 0
                    || indexOfSeq(d, new byte[]{'A', 'N', 'M', 'F'}) >= 0;
        }
        return false; // 真正的 JPEG / 普通 PNG 等：静态
    }

    // Graphic Control Extension: 0x21 0xF9 0x04，出现 >=2 次视为多帧动画
    private static int countGifFrames(byte[] d) {
        int count = 0;
        for (int i = 0; i + 2 < d.length; i++) {
            if (d[i] == 0x21 && (d[i + 1] & 0xFF) == 0xF9 && (d[i + 2] & 0xFF) == 0x04) {
                if (++count > 1) return count;
            }
        }
        return count;
    }

    private static int indexOfSeq(byte[] d, byte[] seq) {
        outer:
        for (int i = 0; i + seq.length <= d.length; i++) {
            for (int j = 0; j < seq.length; j++) if (d[i + j] != seq[j]) continue outer;
            return i;
        }
        return -1;
    }

    private static byte[] readCapped(File f, int cap) throws IOException {
        int n = (int) Math.min(f.length(), cap);
        byte[] buf = new byte[n];
        try (FileInputStream in = new FileInputStream(f)) {
            int off = 0;
            while (off < n) {
                int r = in.read(buf, off, n - off);
                if (r < 0) break;
                off += r;
            }
        }
        return buf;
    }
}