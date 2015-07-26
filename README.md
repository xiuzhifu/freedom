##offline, a skynet demo   
##run
###1. run redis-server first
###2. 
git clone https://github.com/xiuzhifu/offline.git   
git submodule init   
git submodule update   
cd skynet    
make macosx(select your os)   
cd ..   
./run.sh   
###3. cd src 
lua client.lua

##说明
demo类似于现在所谓的那些放置类手游，创建了角色，就开始在场景中打怪，得经验，爆装备，得金钱。   
把一个场景的boss打过了，可以去下一个场景，暂时只配置了一个场景    
fightscene_conf.lua配置每个场景中遇到的怪   
item_conf.lua配置所有的道具   
monster_conf.lua配置怪物   
drop_loot_conf.lua配置怪物爆率   
player_conf.lua配置角色   
player_upgradeexp_conf配置角色的升级经验


