# 插件名称 

docker_build

# 功能说明

用于构建docker images

# 参数说明

| 参数名称 | 类型 | 默认值 | 是否必须 | 含义 |
|---|---|---|---|---|
| docker.image | string | NULL | **必须** | 构建镜像名称 |
| docker.path | string | . | **必须** | 构建镜像的工作目录 |
| docker.build.raw.args | string | '' | **非必须** | 构建镜像可以自定义命令行 |
| artifact.host | string | NULL | **非必须** | 构建镜像参数，${ARTIFACT_HOST} |
| artifact.lane | string | NULL | **非必须** | 构建镜像参数，${ARTIFACT_LANE} |
| group.id.path | string | NULL | **非必须** | 构建镜像参数，${GROUP_ID_PATH} |
| artifact.id | string | NULL | **非必须** | 构建镜像参数，${ARTIFACT_ID} |
| artifact.version | string | NULL | **非必须** | 构建镜像参数，${ARTIFACT_VERSION} |


# 配置使用样例

```yml
stages:
- name: docker_build
  tasks:
    - task.id: docker_build
      docker.image: hello/world:1.0.0
      docker.path: hello
```
