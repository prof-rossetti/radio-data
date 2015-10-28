-- run this script after loading the data into a dbms
-- ... to produce datasets for use in charting, statistical analysis, or other decision-making purposes

-- generate listener_activity_report.csv
SELECT
  l.full_name AS listener_full_name
  ,l.email_address AS listener_email_address
  ,p.started_playing_at AS listen_started_at
  ,s.title AS song_title
  ,s.artist_name AS song_artist_name
  ,s.duration_milliseconds AS song_duration_ms
  ,s.year_recorded AS song_year_recorded
FROM listeners l
INNER JOIN plays p ON l.id = p.listener_id
INNER JOIN songs s ON s.id = p.song_id
ORDER BY l.full_name, s.title, s.artist_name, p.started_playing_at DESC
INTO OUTFILE '~/projects/gwu-business/radio-DATA/reports/listener_activity_report.csv'
  FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
;
