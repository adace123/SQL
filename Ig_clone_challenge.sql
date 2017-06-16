select username from users order by created_at limit 5;


select count(username) as total,dayname(created_at) as day from users group by day order by total desc,day;


select username,photos.id from users left join photos on users.id = photos.user_id where photos.id is null;


select username, image_url, count(*) as likes_count from  photos join likes on likes.photo_id = photos.id join users on photos.user_id=users.id group by likes.photo_id order by likes_count desc limit 1


select(select count(*) from photos)/(select count(*) from users) as average_posts;


select tag_name,count(*) times_used from photo_tags join tags on tags.id = photo_tags.tag_id group by tag_id order by times_used desc limit 5;


select username as likely_bots,count(user_id) as total from likes join users on likes.user_id = users.id 
group by user_id having total = (select count(*) from photos) order by username;  
