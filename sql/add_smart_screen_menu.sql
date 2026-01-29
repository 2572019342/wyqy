-- 添加智慧大屏菜单
-- 注意：执行前请先确认当前最大的menu_id，避免冲突

-- 1. 添加智慧大屏主菜单（作为外链菜单）
INSERT INTO `sys_menu` VALUES (
    3000, 
    '智慧大屏', 
    0, 
    5, 
    'http://192.168.1.247:1145', 
    NULL, 
    '', 
    '', 
    0, 
    1, 
    'M', 
    '0', 
    '0', 
    '', 
    'monitor', 
    'admin', 
    NOW(), 
    '', 
    NULL, 
    '智慧大屏外链菜单'
);

-- 2. 为admin角色分配智慧大屏菜单权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1, 3000);

-- 说明：
-- menu_id: 3000 (假设当前最大menu_id小于3000)
-- parent_id: 0 (顶级菜单)
-- order_num: 5 (显示顺序，排在系统管理、系统监控、系统工具、若依官网之后)
-- path: 'http://192.168.1.247:1145' (外链地址)
-- is_frame: 0 (是外链)
-- is_cache: 1 (不缓存)
-- menu_type: 'M' (目录类型，作为外链使用)
-- visible: '0' (显示)
-- status: '0' (正常)
-- icon: 'monitor' (监控图标)

-- 执行完成后，需要重启后端服务或清除缓存，菜单才会生效
