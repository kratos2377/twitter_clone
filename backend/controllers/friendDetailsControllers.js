import { v4 as uuidv4 } from 'uuid';
import {userPool} from '../pool_queries/queries.js'
import asyncHandler from 'express-async-handler'


const followUser = asyncHandler(async(req , res) => {
    const {user_uid , person_uid} = req.body;

  
             
           userPool.query('UPDATE friends_details SET following = (ARRAY[$1::UUID] || following) WHERE user_id = $2' , [person_uid , user_uid] , (err , result) => {
            if(err){
                res.json({
                    success: false,
                    type: "update_following_error"
                })
            } else{
                userPool.query('UPDATE friends_details SET followers = (ARRAY[$1::UUID] || followers) WHERE user_id = $2' , [user_uid , person_uid ] , (err , result) => {
                    if(err){
                        console.log(err)
                        res.json({
                            success: false,
                            type: "update_follow_error"
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

const unfollowUser = asyncHandler(async(req , res) => {
    const {user_uid , person_uid} = req.body;

             userPool.query('UPDATE friends_details SET following = array_remove(following , $1) WHERE user_id = $2' , [person_uid , user_uid] , (err , result) => {
                if(err){
                    console.log(err)
                    res.json({
                        success: false,
                        type: "unfollow_error"
                    })

                    return;
                } else{
                    userPool.query('UPDATE friends_details SET followers = array_remove(followers , $1) WHERE user_id = $2' , [ user_uid , person_uid ] , (err , result) => {
                        if(err){
                            res.json({
                                success: false,
                                type: "update_unfollow_error"
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

const allFollowandUnfollowDetails = asyncHandler(async(req , res) => {
    const {user_uid} = req.body

    userPool.query('SELECT * FROM friends_details WHERE user_id = $1' , [user_uid] , (err , result) => {
        if(err){
            res.json({
                success: false,
                type: "error"
            })

            return;
        }
        res.json({
            success: true,
            data: result.rows[0]
        })


    })
})


export {followUser , unfollowUser , allFollowandUnfollowDetails}