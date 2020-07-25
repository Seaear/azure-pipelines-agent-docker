# azure-pipelines-agent-docker
Azure Pipelines Agent Docker

https://docs.microsoft.com/zh-cn/azure/devops/pipelines/agents/docker?view=azure-devops

```
docker run -d --name dockeragent -e AZP_URL=<Azure DevOps instance> -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent -v /var/run/docker.sock:/var/run/docker.sock seaear/azure-pipelines-agent:latest
```
