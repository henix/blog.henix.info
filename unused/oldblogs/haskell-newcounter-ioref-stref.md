　　newCounter 是用来理解闭包的一个典型函数，js 版如下：

#{= highlight([=[
function newCounter() {
    var i = 0;
    return function() {
        return i++;
    };
}

var c1 = newCounter();
var c2 = newCounter();
console.log(c1(), c1());
console.log(c2());
]=], 'js', {lineno=true}) }#

　　该函数返回一个函数，返回的函数被调用时依次返回 0, 1, 2, ... 序列。

　　用 Haskell 的 IORef 和 STRef 实现 mutable state 如下（不容易想到的是 newCounter 的类型，Monad 套 Monad）：

#{= highlight([=[
import Control.Monad
import Data.IORef

newCounter :: IO (IO Int)
newCounter = do {
  counter <- newIORef (0::Int);
  return $ do {
    i <- readIORef counter;
    writeIORef counter (i+1);
    return i
    }
  }

main :: IO ()
main = do {
  c1 <- newCounter;
  x1 <- c1;
  x2 <- c1;
  c2 <- newCounter;
  y1 <- c2;
  print x1;
  print x2;
  print y1;
  }
]=], 'haskell', {lineno=true}) }#
 
#{= highlight([=[
import Control.Monad.ST
import Data.STRef

newCounter :: ST s (ST s Int)
newCounter = do {
  counter <- newSTRef (0::Int);
  return $ do {
    i <- readSTRef counter;
    writeSTRef counter (i+1);
    return i
    }
  }

main :: IO ()
main = print $ runST $ do {
  c1 <- newCounter;
  x1 <- c1;
  x2 <- c1;
  c2 <- newCounter;
  y1 <- c2;
  return (x1, x2, y1)
  }
]=], 'haskell', {lineno=true}) }#

　　总结：

1. js 中“不纯”的函数到 Haskell 里就不能再用函数实现了，而必须用 do block
2. 一个返回 a 的带副作用的函数，其类型为 IO a 或 ST s a ，而一个返回这样的函数的函数（每次返回的都不一样，所以也是带副作用的）的类型为 IO (IO a) 或 ST s (ST s a)
