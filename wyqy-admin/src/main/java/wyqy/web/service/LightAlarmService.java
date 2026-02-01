package wyqy.web.service;

import wyqy.web.controller.light.YX5285RController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

/**
 * 小灯（YX5285R 声光报警器）控制服务
 * 通过串口发送指令控制黄灯常亮/熄灭
 */
@Service
public class LightAlarmService {

    private static final Logger log = LoggerFactory.getLogger(LightAlarmService.class);

    @Value("${light-alarm.enabled:false}")
    private boolean enabled;

    @Value("${light-alarm.port:COM5}")
    private String port;

    @Value("${light-alarm.baud-rate:9600}")
    private int baudRate;

    private YX5285RController controller;

    @PostConstruct
    public void init() {
        if (!enabled) {
            log.info("小灯控制已禁用 (light-alarm.enabled=false)");
            return;
        }
        try {
            controller = new YX5285RController(port, 0xFF);
            if (controller.open(baudRate)) {
                log.info("小灯串口已打开: {} @ {} baud", port, baudRate);
            } else {
                log.warn("无法打开小灯串口: {}，小灯控制将不可用", port);
                controller = null;
            }
        } catch (Exception e) {
            log.error("初始化小灯串口失败: {}", e.getMessage());
            controller = null;
        }
    }

    @PreDestroy
    public void destroy() {
        if (controller != null) {
            controller.close();
            log.info("小灯串口已关闭");
        }
    }

    /**
     * 黄灯常亮
     */
    public boolean yellowSteady() {
        if (!enabled || controller == null) {
            log.debug("小灯控制不可用，跳过黄灯常亮");
            return false;
        }
        try {
            boolean ok = controller.yellowSteady();
            if (ok) {
                log.info("小灯黄灯已常亮");
            } else {
                log.warn("小灯黄灯常亮指令发送失败");
            }
            return ok;
        } catch (Exception e) {
            log.error("小灯黄灯常亮失败: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 熄灭小灯
     */
    public boolean turnOff() {
        if (!enabled || controller == null) {
            log.debug("小灯控制不可用，跳过熄灭");
            return false;
        }
        try {
            boolean ok = controller.turnOff();
            if (ok) {
                log.info("小灯已熄灭");
            } else {
                log.warn("小灯熄灭指令发送失败");
            }
            return ok;
        } catch (Exception e) {
            log.error("小灯熄灭失败: {}", e.getMessage());
            return false;
        }
    }

    public boolean isEnabled() {
        return enabled && controller != null;
    }
}
