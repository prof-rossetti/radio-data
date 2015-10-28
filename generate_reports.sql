-- run this script after loading the data into a dbms
-- ... to produce datasets for use in charting, statistical analysis, or other decision-making purposes

/*

generate 'activity_report.csv' file:

*/

SELECT
  'listener_full_name'
  ,'listener_email_address'
  ,'started_listening_at'
  ,'song_title'
  ,'artist_name'
  ,'song_duration_ms'
  ,'year_recorded'
  ,'feedback'
  ,'feedback_given_at'
  ,'skipped'
  ,'skipped_at'
UNION ALL
SELECT
  l.full_name AS listener_full_name
  ,l.email_address AS listener_email_address
  ,p.started_playing_at AS listen_started_at
  ,s.title AS song_title
  ,s.artist_name AS song_artist_name
  ,s.duration_milliseconds AS song_duration
  ,s.year_recorded AS song_year_recorded
  ,th.thumb_type
  ,th.thumb_pressed_at
  ,IF(sk.skipped_at IS NULL,0,1) AS skipped
  ,sk.skipped_at
FROM plays p
JOIN listeners l ON l.id = p.listener_id
JOIN songs s ON s.id = p.song_id
LEFT JOIN thumbs th ON th.play_id = p.id
LEFT JOIN skips sk ON sk.play_id = p.id
-- ORDER BY l.full_name, s.title, s.artist_name, p.started_playing_at DESC
INTO OUTFILE '~/projects/gwu-business/radio-data/reports/activity_report.csv'
  FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
;
