package henix.blog

case class TagPost(
  postId: String,
  tag: String
)

case class Blogpost(
  id: String,
  title: String,
  publish_time: Int,
  cate: String
)

case class Memo[A, B](f: A => B) extends (A => B) {
  private val cache = scala.collection.mutable.Map.empty[A, B]
  def apply(x: A) = cache.getOrElseUpdate(x, f(x))
}

object Blog {
  import scala.io.Source

  lazy val tagId: Map[String, String] = {
    val src = Source.fromFile("tags.db")
    val res = src.getLines.map(_.split('\t')).map(ar => (ar(0), ar(1))).toMap
    src.close()
    res
  }

  lazy val getCatename: Map[String, String] = {
    val src = Source.fromFile("category.db")
    val res = src.getLines.map(_.split('\t')).map(ar => (ar(0), ar(1))).toMap
    src.close()
    res
  }

  lazy val tagposts: List[TagPost] = {
    val src = Source.fromFile("tagpost.db")
    val res = src.getLines.map(_.split('\t')).map(ar => TagPost(ar(0), ar(1))).toList
    src.close()
    res
  }

  lazy val posts: List[Blogpost] = {
    val src = Source.fromFile("posts.db")
    val res = src.getLines.map(_.split('\t')).map(ar => Blogpost(ar(0), ar(1), ar(2).toInt, ar(3))).toList
    src.close()
    res
  }

  lazy val postById: Map[String, Blogpost] = posts.map((s) => (s.id, s)).toMap

  lazy val comnumById: Map[String, Int] = {
    val src = Source.fromFile("comments.db")
    val res = src.getLines.map(_.split('\t')).map(ar => (ar(0), ar(1).toInt)).toMap
    src.close()
    res
  }

  class TagBuild(tag: String) {
    lazy val posts: List[Blogpost] = Blog.tagposts.filter({_.tag == tag}).map(_.postId).map(Blog.postById).sortBy(_.publish_time).reverse
    lazy val weight: Double = 1.0 / math.log1p(posts.length)
  }

  val tags: Memo[String, TagBuild] = Memo(new TagBuild(_))

  class BlogBuild(post: Blogpost) {
    lazy val tags: List[String] = Blog.tagposts.filter({_.postId == post.id}).map(_.tag)
    lazy val weight: Double = tags.map(Blog.tags(_).weight).sum
    lazy val relaposts: List[Blogpost] = Blog.posts
      .filter(_ != post)
      .filter((p: Blogpost) => relative((this, Blog.blogs(p))) > 0)
      .sortBy((p: Blogpost) => relative((this, Blog.blogs(p))))
      .reverse.take(5)

    lazy val random = new scala.util.Random()
    lazy val randposts: List[Blogpost] = random.shuffle(Blog.posts).take(5)
  }

  val blogs: Memo[Blogpost, BlogBuild] = Memo(new BlogBuild(_))

  val coweight: Memo[(BlogBuild, BlogBuild), Double] = Memo {
    case (p1: BlogBuild, p2: BlogBuild) => p1.tags.toSet.intersect(p2.tags.toSet).map(Blog.tags(_).weight).sum
  }

  val relative: Memo[(BlogBuild, BlogBuild), Double] = Memo {
    case (p1: BlogBuild, p2: BlogBuild) => coweight((p1, p2)) / (p1.weight + p2.weight - coweight((p1, p2)))
  }

  class CateBuild(val catid: String) {
    lazy val catname: String = Blog.getCatename(catid)
    lazy val posts: List[Blogpost] = Blog.posts.filter(_.cate == catid).sortBy(_.publish_time).reverse
  }

  val cates: Memo[String, CateBuild] = Memo(new CateBuild(_))
}

object Main {
  private def updateFile(fname: String, str: String) {
    import java.io.File
    import java.io.FileInputStream
    import java.io.FileOutputStream
    import org.apache.commons.io.IOUtils
    import org.apache.commons.io.Charsets

    val file = new File(fname)
    val content: String = if (file.exists()) {
      val fin = new FileInputStream(fname)
      val tmp = IOUtils.toString(fin, Charsets.UTF_8)
      fin.close()
      tmp
    } else null

    if (content == null || content != str) {
      val fout = new FileOutputStream(fname)
      IOUtils.write(str, fout, Charsets.UTF_8)
      fout.close()
    }
  }

  def main(args: Array[String]) {
    val sysprop = new scala.sys.SystemProperties()
    // 1. posts
    val postPath = sysprop("postpath")
    println("Generating " + postPath)
    Blog.posts.foreach(post => {
      val build = Blog.blogs(post)
      val lua = """{
  name = '""" + post.id + """',
  title = '""" + post.title + """',
  publish_time = """ + post.publish_time + """,
  catid = '""" + post.cate + """',
  catname = '""" + Blog.getCatename(post.cate) + """',
  comment_count = """ + Blog.comnumById.getOrElse(post.id, 0) + """,
  tags = {
""" +
build.tags.map((t) => "    { id = '" + Blog.tagId(t) + "', name = '" + t + "' },").mkString("\n") + 
"""
  },
  relaposts = {
""" +
build.relaposts.map((p) => "    { id = '" + p.id + "', title = '" + p.title + "' },").mkString("\n") +
"""
  },
  randposts = {
""" +
build.randposts.map(p => "    { id = '" + p.id + "', title = '" + p.title + "' },").mkString("\n") +
"""
  }
}
"""
      updateFile(postPath + "/" + post.id + ".lua", lua)
    })
    // 2. tags
    val tagPath = "build/tag"
    println("Generating " + tagPath)
    Blog.tagId.foreach {
      case (tagname, tagid) => {
        val lua = "{ tagid = '" + tagid + "', tagname = '" + tagname + "', posts = {" +
          Blog.tags(tagname).posts.map(p => "'" + p.id + "'").mkString(", ") + "} }\n"
        updateFile(tagPath + "/" + tagid + ".lua", lua)
      }
    }
    // 3. index
    val indexPath = "build"
    println("Generating " + indexPath + "/index.lua")
    ;{
      val categories = Blog.getCatename.keys.map(Blog.cates(_)).toList.sortBy(_.posts.head.publish_time).reverse
      val popular: List[Blogpost] = Blog.posts.sortBy(p => Blog.comnumById(p.id)).reverse.take(10)
      val lua = """{
  categories = {
""" +
categories.map(
  cb => "    { catid = '" + cb.catid + "', catname = '" + cb.catname + "', posts = {" + cb.posts.map(p => "'" + p.id + "'").mkString(", ") + "} },"
).mkString("\n") +
"""
  },
  populars = {
""" +
popular.map(
  p => "    { id = '" + p.id + "', title = '" + p.title + "', comnum = " + Blog.comnumById.getOrElse(p.id, 0) + " },"
).mkString("\n") +
"""
  }
}
"""
      updateFile(indexPath + "/index.lua", lua)
    }
    // 4. rss
    println("Generating " + indexPath + "/rss.lua")
    ;{
      val posts = Blog.posts.sortBy(_.publish_time).reverse.map(
        p => "{ id = '" + p.id + "', title = '" + p.title + "', publish_time = " + p.publish_time +
        ", catname = '" + Blog.getCatename(p.cate) + "', tags = {" + Blog.blogs(p).tags.map(t => "'" + t + "'").mkString(", ") + "} }"
      )
      val lua = """{
  posts = {
""" +
posts.map(s => "    " + s + ",").mkString("\n") +
"""
  }
}
"""
      updateFile(indexPath + "/rss.lua", lua)
    }
  }
}
