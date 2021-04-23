import asyncHandler from 'express-async-handler'
import User from '../models/UserModel.js'
import generateToken from '../utils/generateToken.js'
import {userPool} from '../pool_queries/queries.js'
import { v4 as uuidv4 } from 'uuid';
import bcrypt from 'bcryptjs'

const loginUser = asyncHandler(async (req , res) => {
    const {email , password} = req.body;
    


    userPool.query('SELECT * FROM users WHERE email = $1 ' , [email] , async (err , result) => {
        if (err) {
            res.json({
                success: false,
                type: "error"
            })
          }
          else{
             const result_pass = await bcrypt.compare(password ,result.rows[0]['password'])
             if(!result_pass){
              res.json({
                  success: false,
                  type: "wrong_password"
              })
             } else{
                 const result_row = result.rows[0]
                 res.json({
                     success: true,
                     _id: result_row['user_uid'],
                     name: result_row['user_real_name'],
                     email: result_row['email'],
                     username: result_row['user_name'],
                     bio: result_row['bio'],
                     photoUrl: result_row['photourl'],
                     token: generateToken(result_row['user_uid'])
                 }) 

             }
            
          }
          



    })
      
    
    // console.log(email)
    // if(user && (await user.matchPassword(password))){
    //     res.json({
    //         success:true,
    //         _id: user._id,
    //         name: user.name,
    //         password: user.password,
    //         username: user.username,
    //         token: generateToken(user._id)
    //     })

    // } else {
    //     res.json({
    //         success:false
    //     })
    // }
})


const registerUser = asyncHandler(async (req , res) => {
    const {email , username , password , name} = req.body


    userPool.query('SELECT * FROM users WHERE email = $1' , email , (err , result) => {
           if(!err){
               res.json({
                   success: false,
                   type: "email"
               })

               return;
           }
    })
    userPool.query('SELECT * FROM users WHERE user_name = $1' , username , (err , result) => {
           if(!err){
               res.json({
                   success: false,
                   type: "username"
               })

               return;
           }
    })

    const salt = await bcrypt.genSalt(10)
    const hashedPassword = await bcrypt.hash(password , salt)

    const uuid_user = uuidv4()
     
    userPool.query('INSERT INTO users (user_uid , user_real_name , user_name , password , email ) VALUES ($1 , $2 , $3 , $4 , $5)' , [uuid_user , name , username , hashedPassword , email] , (error , result) => {
        if (error) {
            res.json({
                success: false,
                type: "error"
            })
          }

          userPool.query('INSERT INTO friends_details(user_id) VALUES($1)' , [uuid_user] , (err , result)=> {
              if(err){
                  res.json({
                    success: false,
                type: 'friend_table_form_failed'
                })
              }
              else{
                res.status(201).json({
                    success: true,
                    _id: uuid_user,
                  name: name,
                  email: email,
                  password: password,
                  username: username,
          token: generateToken(uuid_user)
                })
              }
          })
      
    })

  
    // const user = await User.findOne({email})
    // const user1 = await User.findOne({ username})

    // if(user || user1){
    //       if(user){
    //           throw new Error("Email Already in use. Use Another Email")
    //       } else{
    //         throw new Error("Username Already in use. Choose Another One")
    //       }
    // }


    // const newUser = await User.create({email , username , password , name  })

    // if(newUser) {
    //     res.json({
    //         success: true,
    //         _id: newUser._id,
    //         name: newUser.name,
    //         email: newUser.email,
    //         password: newUser.password,
    //         username: newUser.username,
    //         token: generateToken(newUser._id)
    //     })
    // } else{
    //     res.status(501)
    //     console.log("FAILED MFS")
    //     throw new Error("Some Error Occured. Try Again")
    // }
})

const updateUser = asyncHandler(async(req , res) => {
    const {name , username , bio , user_uid} = req.body
    userPool.query("SELECT * FROM users WHERE user_name = $1" , [username] , (err , result) => {
        if(result.rows.length == 0){
            userPool.query('UPDATE users SET user_real_name = $1 , user_name = $2 , bio = $3 WHERE user_uid = $4' , [name , username , bio , user_uid] , (err , result) => {
                if(err){
                    res.json({
                        success:false,
                        type: "update_profile_failed"
                    })
                } else{
                    res.json({
                        success:true,
                        type: "update_profile_success",
                        name: name,
                        username: username, 
                        bio: bio
                    })
                }
            })

            return;
        }

        res.json({
            success:false,
            type: "user_name_exists"
        })
    })

    
})

const changePassword = asyncHandler(async(req , res) => {

    const {password , newPassword , user_uid} = req.body;

    userPool.query('SELECT * FROM users WHERE user_uid = $1' , [user_uid] , async (err , result) => {

        if(err){
            res.json({
                success: false,
                type: "some_password_change error"
            })
        }

        else{
            if(bcrypt.compare(password , result.rows[0]['password'])){

                const salt = await bcrypt.genSalt(10)
                const hashedPassword = await bcrypt.hash(newPassword , salt)
               userPool.query('UPDATE users SET password = $1 WHERE user_uid = $2' , [hashedPassword , user_uid] , (err , result) => {
                   if(err){
                       res.json({
                           success: true,
                           type: "password_update_failed"
                       })
                   } else{
                       res.json({
                           success: true
                       })
                   }
               })
            } 

            else{
                res.json({
                    success:false,
                    type: "passwords_dont_match"
                })
            }
        }
        
    })

})

const changePhotoUrl = asyncHandler(async(req , res) => {
    const {user_uid , photoUrl} = req.body

    userPool.query('UPDATE users SET photoUrl = $1 WHERE user_uid = $2' , [ photoUrl , user_uid] , (err , result) => {
        if(err){
            res.json({
                success:false,
                type: "PhotoUrl_update_failed"
            })
        } else{
           res.json({
               success: true,
               
           })
        }
    })
})

const getAllUsers = asyncHandler(async(req , res) => {
    
  userPool.query('SELECT * FROM users' , (err , result) => {
      if(err){
          res.json({
              success: false,
              type: "get_Error"
          })

          return;
      }

      res.json({
          success: true,
          data: result.rows
      })
  })

})

const getEverything = asyncHandler(async(req , res) => {
     const {user_uid} = req.body


     userPool.query('SELECT * FROM users WHERE user_uid = $1' , [user_uid] , (err , result) => {
         if(err){
             res.json({
                 success: false,
                 type: "cannot_fetch"
             })

             return;
         }

         res.json({
             success: true,
             _id: result.rows[0]['user_uid'],
             name: result.rows[0]['user_real_name'],
             email: result.rows[0]['email'],
             username: result.rows[0]['user_name'],
             bio: result.rows[0]['bio'],
             photoUrl: result.rows[0]['photourl'],
         })


     })
})

export { loginUser , registerUser , updateUser , changePassword , changePhotoUrl , getAllUsers , getEverything}