![Build](https://github.com/0xERR0R/gh-backup-docker/workflows/Build/badge.svg)

# GitHub backup

Creates backup of all relevant GitHub user data.

## Configuration

Please set following environment variables:

**GH_USER** GitHub username

**GH_ACCESS_TOKEN** Access Token (Settings -> Developer settings -> Personal Access Token. Should have repo and workflow priveleges)

**DEFAULT_BACKUP_ENTITIES** Optional parameter, which entities should be backed up. See https://github.com/josegonzalez/python-github-backup  

Default if not set: `--starred --watched --followers --following --issues --labels  --milestones --repositories --wikis --gists --starred-gists --private --releases`

Backup zip will be stored in `/out`. Should be mapped as volume (e.g. samba/nfs mount)

## Complete example with docker-compose

create backup.env with following content:

```bash
GH_USER=xxx
GH_ACCESS_TOKEN=xxx
```

Following `docker-compose.yml` starts backup (once). You should trigger the execution per cron `docker-compose run backup` or by using of external tools like [crony](https://github.com/0xERR0R/crony). You can also use this image as a Kubernetes CronJob. Following `docker-compose.yml` will store backup on a samba mounted directory (NAS).

```yaml
version: '2.2'
services:
   backup:
      image: spx01/gh-backup
      env_file: 
      - backup.env
      container_name: gh-backup
      init: true
      volumes:
      - backup:/out     
volumes:
   bitwarden:
   backup:
      driver: local
      driver_opts:
        type: cifs
        o: username=xx,password=xx,rw
        device: //IP_NAS/path/to/folder
```

Credits: Thanks to `josegonzalez` for the github-backup: https://github.com/josegonzalez/python-github-backup
