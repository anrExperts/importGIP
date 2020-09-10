xquery version "3.1";

declare namespace xpr = "xpr" ;
declare default element namespace "xpr" ;

declare
 function local:addGip1726() {
    copy $d := db:open('gip')
    modify (
      let $gip1726 := fn:doc('/Volumes/data/github/xprgip/output/1726-xpr.xml')
      for $expertise in $gip1726//expertise
      return insert node $expertise as last into $d//expertises
     )
    return $d
};

declare
%updating
function local:replaceDb() {
    let $gip := local:addGip1726()
    let $dbName := 'gipb1726'
    return (
        file:write(file:base-dir() || 'gip' || '.old' || '.xml', $gip),
        db:copy('gip', $dbName),
        db:drop('gip'),
        db:create("gip", $gip, "gip.xml", map {"chop": fn:false()})
    )
};

local:replaceDb()