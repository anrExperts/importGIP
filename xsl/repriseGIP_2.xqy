xquery version "3.1";

declare namespace xpr = "xpr" ;
declare default element namespace "xpr" ;

declare
 function local:cleanExp() {
    copy $d := db:open('gip')
    modify (
      for $expertise in $d//expertise
      return (
        switch (fn:substring-after($expertise//idno[@type='unitid'], 'Z1J'))
          case '999' return delete node $expertise
          case '1001' return (
            if(fn:number($expertise//idno[@type='item']) > fn:number('20')) then delete node $expertise
            else replace node $expertise with $expertise
          )
          case '1002' return delete node $expertise
          case '1003' return delete node $expertise
          case '1004' return delete node $expertise
          case '1005' return delete node $expertise
          case '1007' return delete node $expertise
          case '1009' return delete node $expertise
          default return replace node $expertise with $expertise
       )
     )
    return $d
};

declare
%updating
function local:replaceDb() {
    let $gip := local:cleanExp()
    let $dbName := 'gipDropLL'
    return (
        file:write(file:base-dir() || 'gip' || '.old' || '.xml', $gip),
        db:copy('gip', $dbName),
        db:drop('gip'),
        db:create("gip", $gip, "gip.xml", map {"chop": fn:false()})
    )
};

local:replaceDb()