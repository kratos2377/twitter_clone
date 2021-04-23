import { v4 as uuidv4 } from 'uuid';
import {userPool} from '../pool_queries/queries.js'
import asyncHandler from 'express-async-handler'


const userTweet = asyncHandler(async(req , res) => {
    const {user_uid  , content} = req.body
    userPool.query('SELECT * FROM tweets WHERE tweet_user_id = $1' , [user_uid] , (err , results) =>{

        if(results.rows.length == 0){
            const tweet_id = uuidv4()
            const data = [{
                "tweet_uid": tweet_id,
                "tweet_content": content,
                "type_of": user_uid
            }]
            
            userPool.query('INSERT INTO tweets(tweet_user_id , user_tweets) VALUES($1 , $2::jsonb[])' , [user_uid , data ] , (err , result) => {
                if(err){
                    res.json({
                        success:false,
                        type: "cannot_tweet"
                    })
                }

                else{
                    res.json({
                        success:true,
                        data: tweet_id
                    })
                }
            })
        } else{
            const tweet_id_new = uuidv4()
            const data = [{
                "tweet_uid": tweet_id_new,
                "tweet_content": content,
                "type_of": user_uid
            }]
            userPool.query('UPDATE tweets SET user_tweets = ($1::jsonb[] || user_tweets) WHERE tweet_user_id = $2' , [data , user_uid] , (err , result) => {
                if(err){
                    res.json({
                        success:false,
                        type: "cannot_tweet_2"
                    })
                } else{
                    res.json({
                        success:true,
                        data: tweet_id_new
                    })
                }
            })
        }
    })

   
})


// Comeback here later

const shareTweet = asyncHandler(async(req , res) => {
    const {user_uid  , tweet_id} = req.body
    

    userPool.query('SELECT * FROM tweets WHERE tweet_user_id = $1' , [user_uid] , (err , result) =>{
        if(result.rows.length == 0){
            // const data = [{
            //     "tweet_id": 
            // }]
            userPool.query('INSERT INTO tweets(tweet_user_id , user_tweets) VALUES($1 , $2::jsonb[]))' , [user_uid , tweet_id , content , 'retweet'  ] , (err , result) => {
                if(err){
                    res.json({
                        success:false,
                        type: "cannot_tweet"
                    })
                }

                else{
                    res.json({
                        success:true,
                        data: result.rows
                    })
                }
            })
        } else{
            userPool.query('UPDATE tweets SET user_tweets = (ROW($1 , $2 , $3 )::jsonb|| user_tweets) WHERE tweet_user_id = $4' , [tweet_id , content , 'retweet' , user_uid] , (err , result) => {
                if(err){
                    res.json({
                        success:false,
                        type: "cannot_tweet_2"
                    })
                } else{
                    res.json({
                        success:true,
                        data: result.rows
                    })
                }
            })
        }
    })

})

const getUserTweets =  asyncHandler(async(req , res) => {
    const {user_uid} = req.body

    userPool.query("SELECT user_tweets FROM tweets WHERE tweet_user_id = $1" , [user_uid] , (err , result) => {
        if(err){
            res.json({
                success: false,
            })

            return;
        }

        res.json({
            success:true,
            data: result.rows.length == 0 ? result.rows : result.rows[0]['user_tweets']
        })
    })
    
})

const    getFeed = asyncHandler(async(req , res) => {
    const {user_uid} = req.body

userPool.query('SELECT DISTINCT tweets.user_tweets F FROM tweets JOIN friends_details ON tweets.tweet_user_id = ANY (friends_details.following) WHERE friends_details.user_id = $1' , [user_uid] , (err , result)=> {
  if(err){
      res.json({
          success: false
      })

      return;
  }

  res.json({
      success: true,
      data: result.rows
  })
    } )
})


const topHashTags = asyncHandler(async(req , res) => {

    userPool.query("SELECT * FROM hashtags ORDER BY number_of_tweets DESC LIMIT 5" , (err , result) => {
        if(err){
            res.json({
                success:false
            })

            return;
        }

        res.json({
            success:true,
            data: result.rows
        })

    })
})

const addTagSystem = asyncHandler(async(req , res) => {
    const {hash_names} = req.body

    
        userPool.query('SELECT * FROM hashtags WHERE hash_name = $1' , [hash_names] , (err , result) => {
            if(result.rows.length == 0){
                userPool.query('INSERT INTO hashtags(hash_name ,  number_of_tweets) VALUES($1 , $2)' , [hash_names , 1] , (err , result) => {
                    if(err){
                        res.json({
                            success:false,
                        })

                        return;
                    }

                    res.json({
                        success: true
                    })
                })
            } else{
                userPool.query('UPDATE hashtags SET number_of_tweets = number_of_tweets+1 WHERE hash_name =  $1' , [hash_names] , (err , result) => {
                    if(err){
                        console.log(err)
                        res.json({
                            success: false
                        })

                        return;
                    }

                    res.json({
                        success: true
                    })
                })
            }
        })
    
})

export {shareTweet , userTweet , getUserTweets , topHashTags , getFeed ,addTagSystem}