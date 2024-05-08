# searchfeeds


```
git clone hhttps://github.com/VictorCuralea/public-threat-intel-feeds
cd searchfeeds
```

Run ./download.sh to get fresh data in rawdata/

You can run a cron to get fresh data
Make sure to change /path/ to your path
```
crontab -e
0 * * * * cd /path/searchfeeds && ./download.sh
```
