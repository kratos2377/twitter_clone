import { v4 as uuidv4 } from 'uuid';
import {userPool} from '../pool_queries/queries.js'
import asyncHandler from 'express-async-handler'


const likeTweet = asyncHandler(async(req , res) => {
    const {tweet_id , user_uid} = req.body;

    userPool.query('SELECT * FROM likes WHERE tweet_id = $1' , [tweet_id] , (err , result) => {
        if(result.rows.length == 0){
          userPool.query('INSERT INTO likes(tweet_id , liked_by) VALUES($1 , ARRAY[$2::UUID])' , [tweet_id , user_uid] , (err , result) => {
              if(err){
                  console.log(err)
                  res.json({
                      success: false,
                      type: "like_error"
                  })
              } else{
                  res.json({
                      success: true,
                    })
              }
          })

        } else{
            userPool.query('UPDATE likes SET liked_by = (ARRAY[$1::UUID] || liked_by) WHERE tweet_id = $2' , [ user_uid , tweet_id] , (err , result) => {
                if(err){
                    res.json({
                        success: false,
                        type: "update_like_error"
                    })
                } else{
                    res.json({
                        success: true,
                      })
                }
            })
        }
    })
})

const commentOnTweet = asyncHandler(async(req , res) => {
    
    const {tweet_id , user_uid , content } = req.body;

    userPool.query('SELECT * FROM comment WHERE tweet_id = $1' , [tweet_id] , (err , result) => {
        if(result.rows.length == 0){
            const comment_uid = uuidv4()
          userPool.query('INSERT INTO comment(tweet_id , commented_by) VALUES($1 , ARRAY[ROW($2 , $3 , $4 )::comms])' , [tweet_id , comment_uid , user_uid , content] , (err , result) => {
              if(err){
                  res.json({
                      success: false,
                      type: "comment_error"
                  })
              } else{
                  res.json({
                      success: true,
                      comment_id: comment_uid
                    })
              }
          })

        } else{
            const comment_uid = uuidv4()
            userPool.query('UPDATE comment SET commented_by = (ROW($1 , $2 , $3 )::comms || commented_by) WHERE tweet_id = $2' , [ comment_uid , user_uid , content ,tweet_id ] , (err , result) => {
                if(err){
                    res.json({
                        success: false,
                        type: "update_comment_error"
                    })
                } else{
                    res.json({
                        success: true,
                        comment_id: comment_uid
                      })
                }
            })
        }
    })
}) 


const retweeted = asyncHandler(async(req , res) => {
    const {tweet_id} = req.body
    userPool.query('SELECT * FROM retweet WHERE tweet_id = $1' , [tweet_id] , (err , result) => {
        if(result.rows.length == 0){
           userPool.query('INSERT INTO retweet(tweet_id , retweeted_by) VALUES($1 , $2)' , [tweet_id , 1] , (err , result) => {
               if(err){
                   res.json({
                       success:false,
                       type: 'retweet_fail'
                   })
               } else{
                   res.json({
                       success:true,
                       
                    })
               }
           })
        } else{
            userPool.query('UPDATE retweet SET retweeted_by = retweeted_by + 1 WHERE tweet_id = $1' , [tweet_id] , (err , result) => {
                if(err){
                    res.json({
                        success:false,
                        type: 'update_retweet_fail'
                    })
                } else{
                    res.json({
                        success:true,
                        
                     })
                }
            })
        }
    })
})

export {likeTweet , commentOnTweet , retweeted}