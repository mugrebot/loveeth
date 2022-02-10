import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <a href="/">
      <PageHeader
        title="❤️❤️❤️ GWEI-LENTINES ❤️❤️❤️"
        subTitle="on-chain candy hearts!"
        style={{ cursor: "pointer", background: '#893867', size: "small"}}
        
      />
    </a>
  );
}
