一、创建库
git init <库名>
二、创建分支 (打开刚创建的库: cd <库名>)
git branch <分支名>
注：如果创建分支失败，建立一个测试文本文件即可。
1) git add .
2) git commit -a -m "test"
三、切换分支
git checkout <分支名> 
该语句和上一个语句可以和起来用一个语句表示：git checkout -b <分支名>
四、查看当前库所有分支
git branch
五、分支合并
比如，如果要将当前的分支develop，合并到主分支master
首先我们需要切换到master主分支：git checkout master
然后执行合并操作：git merge develop
如果有冲突，会提示你，调用git status查看冲突文件。 
解决冲突，然后调用git add或git rm将解决后的文件暂存。 
所有冲突解决后，git commit 提交更改。
六、分支衍合
分支衍合和分支合并的差别在于，分支衍合不会保留合并的日志，不留痕迹，而 分支合并则会保留合并的日志。 
要将开发中的分支develop，衍合到主分支master
首先切换的master分支：git checkout master
然后执行衍和操作：git rebase develop
如果有冲突，会提示你，调用git status查看冲突文件。 
解决冲突，然后调用git add或git rm将解决后的文件暂存。 
所有冲突解决后，git rebase –continue 提交更改。
七、删除分支
git branch -d <分支名> 
如果该分支没有合并到主分支会报错，可以用以下命令强制删除git branch -D <分支名>
八、删除库
rm -rf <库名>
