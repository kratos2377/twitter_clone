import express from 'express'
const router = express.Router();
import {shareTweet , userTweet , getUserTweets , topHashTags , getFeed
, addTagSystem} from '../controllers/tweetController.js'

router.post('/user', userTweet )
router.post('/share', shareTweet )
router.post('/getTweets', getUserTweets )
router.post('/getTopTweets', topHashTags )
router.post('/addTag' , addTagSystem)
router.post('/getFeed', getFeed )


export default router;