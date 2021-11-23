from textblob import TextBlob
import csv
import tweepy
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

consumer_key= ''
consumer_secret= ''
access_token=''
access_token_secret=''

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)
target_num = int(raw_input())
query = raw_input()
csvFile = open('demo.csv','w')
csvWriter = csv.writer(csvFile)
csvWriter.writerow(["username","authorid","created", "text", "retwc", "followers", "friends","polarity","subjectivity"])
counter=0
for tweet in tweepy.Cursor(api.search,q=query,lang="en",count=target_num).items():
    created = tweet.created_at
    text = (tweet.text).encode('utf8')
    retwc = tweet.retweet_count
    username  = tweet.author.name            
    authorid  = tweet.author.id              
    followers = tweet.author.followers_count
    friends = tweet.author.friends_count
    text_blob = TextBlob(text)
    polarity = text_blob.polarity
    subjectivity = text_blob.subjectivity
    counter=counter+1
    csvWriter.writerow([username, authorid, created, text, retwc, followers, friends, polarity, subjectivity])
    if(counter==target_num):
        break
csvFile.close()
