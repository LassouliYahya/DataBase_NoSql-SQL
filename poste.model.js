const mongoose = require("mongoose");

const postSchema = mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      minlength: 4,
      maxlength: 150,
    },
    body: {
      type: String,
      required: true,
      minlength: 4,
      maxlength: 2000,
    },
    photo: {
      type: String,
      default:"https://res.cloudinary.com/lassouli/image/upload/v1593009611/prof_hpj1e0.jpg"
    },
    likes:[{type: mongoose.Schema.Types.ObjectId,ref:"User"}],
    comments:[{
        text:{type: String},
        postedBy:{type: mongoose.Schema.Types.ObjectId,ref:"User"}
    }],
    postedBy:{
       type: mongoose.Schema.Types.ObjectId,
       ref:"User"
    }
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Post", postSchema);
