-- 创建库（建议显式 charset/collation）
create database if not exists my_db
  default character set utf8mb4
  default collate utf8mb4_unicode_ci;

use my_db;

-- =========================
-- 用户主体表（代表“人”）
-- =========================
create table if not exists users (
  id           bigint auto_increment primary key comment 'id',

  displayName  varchar(128)  null comment '展示昵称',
  avatarUrl    varchar(512)  null comment '头像URL',

  userRole     enum('super','admin','user','ban')
               not null default 'user' comment '用户角色',
  userStatus   tinyint not null default 1 comment '用户状态：1正常 0禁用',

  createTime   datetime not null default current_timestamp comment '创建时间',
  updateTime   datetime not null default current_timestamp on update current_timestamp comment '更新时间',
  deletedAt    datetime null comment '软删时间（null=未删除）',

  index idx_role (userRole),
  index idx_status (userStatus),
  index idx_status_deleted_ct (userStatus, deletedAt, createTime)
) engine=InnoDB comment '用户主体' collate=utf8mb4_unicode_ci;


-- =========================
-- 用户身份表（phone/email）
-- phone：identifier = E.164（+8613800138000）
-- email：identifier = user@example.com（建议应用层 lower() 规范化后入库）
-- =========================
create table if not exists user_identities (
  id            bigint auto_increment primary key comment 'id',
  userId        bigint not null comment '用户 id',

  identityType  enum('phone','email')
                not null comment '身份类型：phone/email',
  identifier    varchar(256) not null comment '唯一标识：手机号E.164/邮箱(建议lower)',

  isVerified    tinyint not null default 0 comment '是否已验证',
  verifiedAt    datetime null comment '验证时间',

  createTime    datetime not null default current_timestamp comment '创建时间',
  updateTime    datetime not null default current_timestamp on update current_timestamp comment '更新时间',
  deletedAt     datetime null comment '软删时间（null=未删除）',

  -- 查询：根据 userId 拉所有身份、或根据 (type,identifier) 定位用户
  index idx_userId (userId),
  index idx_identity_lookup (identityType, identifier),

  -- 约束：同一手机号/邮箱全库唯一（不复用）
  unique key uk_identity (identityType, identifier),

  -- 可选：限制每个用户每种类型最多一条身份（一个用户最多一个 phone、一个 email）
  unique key uk_user_type (userId, identityType),

  -- 可选外键：强一致需要就保留；高并发/分库分表可去掉外键只保留逻辑一致
  constraint fk_identities_user foreign key (userId) references users(id)
) engine=InnoDB comment '用户身份' collate=utf8mb4_unicode_ci;


-- =========================
-- JWT Refresh Token 表（多设备/退出/踢下线）
-- 只存 refreshToken 的 hash（不要存明文）
-- =========================
create table if not exists user_refresh_tokens (
  id               bigint auto_increment primary key comment 'id',
  userId           bigint not null comment '用户 id',

  jti              varchar(64) not null comment 'refresh token 唯一标识（UUID/JTI）',
  refreshTokenHash varchar(255) not null comment 'refresh token 哈希（如sha256/base64/bcrypt等）',

  deviceId         varchar(128) null comment '设备标识（可选）',
  userAgent        varchar(512) null comment 'UA（可选）',
  ip               varchar(45)  null comment 'IP（IPv4/IPv6）',

  expireTime       datetime not null comment '过期时间',
  revokeTime       datetime null comment '吊销时间（退出/踢下线）',
  lastUsedAt       datetime null comment '最后使用时间（刷新时更新）',

  createTime       datetime not null default current_timestamp comment '创建时间',
  updateTime       datetime not null default current_timestamp on update current_timestamp comment '更新时间',

  -- 常用查询：按 jti 定位 / 按 userId 拉设备 / 按过期清理
  unique key uk_jti (jti),
  index idx_userId (userId),
  index idx_user_expire (userId, expireTime),
  index idx_expireTime (expireTime),
  index idx_revokeTime (revokeTime),

  constraint fk_tokens_user foreign key (userId) references users(id)
) engine=InnoDB comment 'JWT Refresh Token' collate=utf8mb4_unicode_ci;


-- =========================
-- 验证码表（统一承载：短信验证码 + 邮箱验证码）
-- channel=sms/email
-- identifier=手机号E.164 或 邮箱（建议lower）
-- =========================
create table if not exists verification_otps (
  id         bigint auto_increment primary key comment 'id',

  channel    enum('sms','email')
             not null comment '通道：sms/email',
  identifier varchar(256) not null comment '手机号E.164或邮箱(建议lower)',
  purpose    enum('login','register','bind','verify','reset')
             not null comment '用途',

  codeHash   varchar(255) not null comment '验证码哈希',
  expireTime datetime not null comment '过期时间',
  usedTime   datetime null comment '使用时间',

  ip         varchar(45) null comment '请求IP（可选）',
  userAgent  varchar(512) null comment 'UA（可选）',

  createTime datetime not null default current_timestamp comment '创建时间',
  updateTime datetime not null default current_timestamp on update current_timestamp comment '更新时间',
  deletedAt  datetime null comment '软删时间（一般不需要删，保留审计）',

  -- 常用查验：按 (channel,identifier,purpose) 找最近未使用且未过期
  index idx_lookup (channel, identifier, purpose, usedTime, expireTime, createTime),
  index idx_expireTime (expireTime)
) engine=InnoDB comment '验证码' collate=utf8mb4_unicode_ci;
